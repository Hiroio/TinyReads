//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation
import FirebaseFirestoreInternal

@Observable
final class ReadsDeckManager {
  static let shared = ReadsDeckManager()
  
  // MARK: - Published State
  /// Firestore cards currently known by the deck.
  /// Text content lives in Firestore/cache; this array is only the active in-memory deck snapshot.
  var reads: [ReadCardModel] = []
  
  /// Local CoreData interaction history for the current user.
  /// This is the source of truth for read/saved/dismissed status and fetch progress.
  var readsInteractions: [ReadInteractionModel] = []
  
  /// Last deck loading error mapped to a UI-friendly state.
  var errorState: CardError?
  
  /// Prevents UI from starting duplicate fetches and lets views show loading state.
  var fetchIsActive: Bool = false
  
  var displayCards: [DisplayReadCard]{
	 makeDisplayReads(from: reads)
  }
  
  // MARK: - Dependencies
  let firestore: PublicReadsServiceProtocol
  let userDefaults: UserDefaultsManagerProtocol
  let coreDataManager = CoreDataService.shared
 
  
  // MARK: - Init
  init(
	 firestore: PublicReadsServiceProtocol = FireStoreService.shared,
	 userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared,
  ) {
	 self.firestore = firestore
	 self.userDefaults = userDefaultsManager
	 
	 loadInitialDeck()
	 
  }
}

// MARK: - Derived Deck State
extension ReadsDeckManager {
  /// Category ids selected by user.
  var categories: [String] {
	 userDefaults.selectedCategories
  }
  /// Language selected by user
  var language: LanguageEnum {
	 userDefaults.selectedLanguage
  }
  
  /// Cards that have not been removed from the current deck session.
  var activeReads: [ReadCardModel] {
	 reads.filter(\.isActive)
  }
  
  /// Cards shown in the default deck mode.
  /// Only active and never-interacted cards are included(fresh cards).
  var freshDisplayReads: [DisplayReadCard] {
	 makeDisplayReads(from: reads)
		.filter { $0.card.isActive && $0.status == .fresh }
		.sorted { $0.card.sortIndex < $1.card.sortIndex }
  }
  
  /// Cards shown when the user wants to revisit old cards.
  /// Includes fresh/read/saved/dismissed cards so UI can display their previous status.
  var repeatDisplayReads: [DisplayReadCard] {
	 makeDisplayReads(from: reads)
		.filter{ $0.status != .fresh && $0.status != .read }
		.sorted{ $0.card.sortIndex < $1.card.sortIndex }
  }
}

// MARK: - Public Loading API
extension ReadsDeckManager {
  /// Initial load of manager to load reads
  func loadInitialDeck() {
	 Task {
		await fetchFreshReads()
		await loadViewedCardsForSelectedCategories()
	 }
  }
  
  /// Loads the next fresh Firestore batch.
  ///
  /// Flow is intentionally direct:
  /// 1. refresh CoreData interactions,
  /// 2. calculate the next sortIndex per selected category,
  /// 3. fetch one Firestore batch,
  /// 4. append unique reads or expose a UI-friendly error.
  func fetchFreshReads() async {
	 guard !fetchIsActive else { return }
	 
	 await MainActor.run {
		self.fetchIsActive = true
		self.errorState = nil
		self.fetchInteractionReads()
	 }
	 
	 do {
		let categoryProgress = try filterInteractions()
		
		let newReads = try await firestore.fetchReads(
		  categoryProgress: categoryProgress,
		  languageCode: userDefaults.selectedLanguage.code,
		  limitPerCategory: 3 // TODO: Change to 25 for production
		)
		
		await MainActor.run {
		  self.appendUniqueReads(newReads)
		  self.errorState = nil
		  self.fetchIsActive = false
		}
	 } catch {
		await MainActor.run {
		  self.errorState = self.mapDeckError(error)
		  self.fetchIsActive = false
		  self.printDeckError(error)
		}
	 }
  }
  
  /// Clears the in-memory deck and loads for new categories/language.
  func reloadForSelectedCategories() async {
	 await MainActor.run {
		self.reads = []
	 }
	 
	 await fetchFreshReads()
	 await loadViewedCardsForSelectedCategories()
  }
  
  /// Loads viewedCards which user has interaction.
  func loadViewedCardsForSelectedCategories() async {
	 let interactedCards = self.readsInteractions.filter {
		$0.languageCode == userDefaults.selectedLanguage.rawValue
		&& categories.contains($0.categoryId)
		&& ($0.isSaved || $0.isSkipped || $0.isRead)
	 }
	 let ids = interactedCards.map { $0.id }
	 
	 let viewedCards = try? await firestore.fetchReads(ids: ids)
	 
	 guard let viewedCards else { return }
	 
	 await MainActor.run {
		self.appendUniqueReads(viewedCards)
		if !viewedCards.isEmpty {
		  self.errorState = nil
		}
	 }
  }
}

// MARK: - Deck Actions
extension ReadsDeckManager {
  /// Removes a card from the current active deck without deleting its Firestore/cache data.
  func removeFromDeck(_ id: String) {
	 guard let index = reads.firstIndex(where: { $0.id == id }) else { return }
	 reads[index].isActive = false
  }
  
  /// Pulls the latest CoreData interaction for one card after Article actions.
  func applyInteractionChange(_ id: String) {
	 guard let entity = coreDataManager.getSingleEntity(by: id) else { return }
	 guard let interaction = try? ReadInteractionModel(entity: entity) else { return }
	 
	 if let index = readsInteractions.firstIndex(where: { $0.id == interaction.id }) {
		readsInteractions[index] = interaction
	 } else {
		readsInteractions.append(interaction)
	 }
  }
  
  func refreshActiveStatus() {
		for i in reads.indices {
			 reads[i].isActive = true
		}
  }
}

// MARK: - CoreData Actions
extension ReadsDeckManager {
  /// Refreshes all local interaction models from CoreData.
  func fetchInteractionReads() {
	 let entities = coreDataManager.fetchReadsEntity()
	 self.readsInteractions = entities.compactMap { try? ReadInteractionModel(entity: $0) }
  }
  
  /// Saves a card to the user's archive.
  @discardableResult
  func saveCard(_ card: ReadCardModel) -> Bool {
	 guard !readsInteractions.contains(where: { card.id == $0.id && !$0.isSaved }) else { return true }
	 
	 var interaction = ReadInteractionModel(
		id: card.id,
		categoryId: card.categoryId,
		languageCode: card.languageCode,
		sortIndex: card.sortIndex
	 )
	 interaction.savedAt = Date.now
	 interaction.isSaved = true
	 
	 let saved = coreDataManager.markSaved(interaction)
	 if saved { fetchInteractionReads() }
	 return saved
  }
  
  /// Marks a card as dismissed/skipped.
  @discardableResult
  func dismissCard(_ card: ReadCardModel) -> Bool {
	 var interaction = ReadInteractionModel(
		id: card.id,
		categoryId: card.categoryId,
		languageCode: card.languageCode,
		sortIndex: card.sortIndex
	 )
	 interaction.isSkipped = true
	 interaction.skippedAt = .now
	 interaction.skipCount += 1
	 
	 let saved = coreDataManager.markDismissed(interaction)
	 if saved { fetchInteractionReads() }
	 return saved
  }
}

// MARK: - Fetch Progress
extension ReadsDeckManager {
  // - Calculate indexes which is not marked.
  /// gettings dict where ["Category" : latest fresh index]
  /// fresh - means not swiped
  func filterInteractions() throws -> [String: Int] {
	 guard !categories.isEmpty else { throw CardError.noCategories }
	 
	 var result: [String: Int] = [:]
	 let languageCode = userDefaults.selectedLanguage.code
	 let languageInteractions = readsInteractions.filter { $0.languageCode == languageCode }
	 
	 for categoryId in categories {
		guard let category = ReadCategories(rawValue: categoryId) else { continue }
		
		let nextSortIndex = languageInteractions.getNextSortIndex(per: categoryId)
		if nextSortIndex <= category.limit {
		  result[categoryId] = nextSortIndex
		}
	 }
	 
	 guard !result.isEmpty else { throw CardError.cardNoLeft }
	 return result
  }
}

// MARK: - Display Mapping
private extension ReadsDeckManager {
  /// Combines Firestore cards with local CoreData interactions for UI.
  func makeDisplayReads(from reads: [ReadCardModel]) -> [DisplayReadCard] {
	 return reads.map { read in
		DisplayReadCard(
		  card: read,
		  status: status(for: read)
		)
	 }
  }
  
  /// Resolves visible UI status for a card.
  ///
  /// Priority matters: read beats archived, archived beats dismissed.
  func status(
	 for read: ReadCardModel
  ) -> ReadCardDisplayStatus {
	 guard let index = readsInteractions.firstIndex(where: {$0.id == read.id }) else { return .fresh }
	 
	 if readsInteractions[index].isRead { return .read }
	 if readsInteractions[index].isSaved { return .archived }
	 if readsInteractions[index].isSkipped { return .dismissed }
	 
	 return .fresh
  }
  
  /// Appends only cards that are not already in the in-memory deck.
  func appendUniqueReads(_ newReads: [ReadCardModel]) {
	 let existingIds = Set(reads.map(\.id))
	 reads.append(contentsOf: newReads.filter { !existingIds.contains($0.id) })
  }
}

// MARK: - Error Mapping
private extension ReadsDeckManager {
  /// Converts low-level fetch errors into UI-friendly card errors.
  func mapDeckError(_ error: Error) -> CardError {
		if let cardError = error as? CardError {
			 return cardError
		}
		
		let nsError = error as NSError
		if nsError.domain == FirestoreErrorDomain {
			 switch nsError.code {
			 case FirestoreErrorCode.unavailable.rawValue:
				  return .badInternetConnection
			 case FirestoreErrorCode.permissionDenied.rawValue,
					FirestoreErrorCode.unauthenticated.rawValue:
				  return .somethingWentWrong
			 default:
				  return .somethingWentWrong
			 }
		}
		
		return .somethingWentWrong
  }
  
  /// Prints original error details before mapping.
  func printDeckError(_ error: Error) {
#if DEBUG
	 let nsError = error as NSError
	 print("""
  ❌ ReadsDeckManager error
  domain: \(nsError.domain)
  code: \(nsError.code)
  description: \(nsError.localizedDescription)
  failureReason: \(nsError.localizedFailureReason ?? "nil")
  recoverySuggestion: \(nsError.localizedRecoverySuggestion ?? "nil")
  userInfo: \(nsError.userInfo)
  mappedState: \(mapDeckError(error))
  """)
#endif
  }
}

// MARK: - Firestore Error Helpers
private extension NSError {
  /// Firestore usually reports internet/offline issues as NSError instead of URLError.
  var isFirestoreNetworkError: Bool {
	 let message = firestoreMessage
	 
	 if code == 14 { return true }
	 if message.contains("network") { return true }
	 if message.contains("offline") { return true }
	 if message.contains("unavailable") { return true }
	 if message.contains("could not reach cloud firestore backend") { return true }
	 
	 return false
  }
  
  /// Firestore sometimes reports an exhausted query/index as an NSError.
  /// These cases are treated as "no cards left" instead of a generic failure.
  var isFirestoreNoCardsError: Bool {
	 let message = firestoreMessage
	 
	 if code == 11 { return true }
	 if message.contains("out of range") { return true }
	 if message.contains("outofrange") { return true }
	 if message.contains("out of index") { return true }
	 
	 return false
  }
  
  var firestoreMessage: String {
	 [
		localizedDescription,
		localizedFailureReason,
		localizedRecoverySuggestion,
		userInfo.description
	 ]
		.compactMap { $0 }
		.joined(separator: " ")
		.lowercased()
		.replacingOccurrences(of: "_", with: " ")
  }
}
