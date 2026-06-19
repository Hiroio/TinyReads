//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

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
  
  // MARK: - Dependencies
  let firestore: PublicReadsServiceProtocol
  let userDefaults: UserDefaultsManagerProtocol
  let coreDataManager = CoreDataService.shared
  
  // MARK: - Private State
  /// Keeps one Firestore loading pipeline alive at a time.
  /// If another caller asks for more reads while loading, it waits for this task.
  private var loadingTask: Task<Void, Never>?
  
  // MARK: - Init
  init(
	 firestore: PublicReadsServiceProtocol = FireStoreService.shared,
	 userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared,
	 autoLoad: Bool = true
  ) {
	 self.firestore = firestore
	 self.userDefaults = userDefaultsManager
	 
	 if autoLoad {
		loadInitialDeck()
	 }
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
  }
}

// MARK: - Public Loading API
extension ReadsDeckManager {
  /// Initial load of manager to load reads
  func loadInitialDeck() {
	 fetchInteractionReads()
	 
	 Task {
		await loadMoreReads()
		await loadViewedCardsForSelectedCategories()
	 }
  }
  
  /// Loads the next Firestore batch.
  /// Errors are stored in `errorState`, ViewModel reads `errorState` to show errors to user.
  func loadMoreReads() async {
	 if let loadingTask {
		await loadingTask.value
		return
	 }
	 
	 let task = Task { [weak self] in
		guard let self else { return }
		await self.performLoadMoreReads()
	 }
	 
	 loadingTask = task
	 await task.value
	 loadingTask = nil
  }
  
  /// Clears the in-memory deck and loads for new categories/language.
  func reloadForSelectedCategories() async {
	 await MainActor.run {
		self.reads = []
	 }
	 
	 await loadMoreReads()
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
	 guard !readsInteractions.contains(where: { card.id == $0.id }) else { return true }
	 
	 var interaction = ReadInteractionModel(
		id: card.id,
		categoryId: card.categoryId,
		languageCode: card.languageCode,
		sortIndex: card.sortIndex
	 )
	 interaction.savedAt = Date.now
	 interaction.isSaved = true
	 
	 let saved = coreDataManager.saveReadEntity(interaction)
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
  /// Builds Firestore progress per selected category.
  ///
  /// The progress is based on CoreData interactions, filtered by the selected app language.
  /// Categories that already reached their known content limit are removed from the fetch request.
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

// MARK: - Loading Pipeline
private extension ReadsDeckManager {
  /// Runs the full load-more pipeline:
  /// refresh interactions, calculate progress, fetch Firestore cards, append unique reads,
  /// and store any error as `errorState`.
  func performLoadMoreReads() async {
	 await MainActor.run {
		self.fetchIsActive = true
		self.errorState = nil
	 }
	 
	 do {
		await MainActor.run {
		  self.fetchInteractionReads()
		}
		
		let categoryProgress = try filterInteractions()
		try await loadMoreReads(categoryProgress: categoryProgress)
		
		await MainActor.run {
		  self.errorState = nil
		  self.fetchIsActive = false
		}
	 } catch {
		await MainActor.run {
		  self.errorState = mapDeckError(error)
		  self.fetchIsActive = false
		  self.printDeckError(error)
		}
	 }
  }
}

// MARK: - Firestore Fetching
private extension ReadsDeckManager {
  /// Fetches cards for selected categories and selected language.
  func fetchReadsCard(categoryProgress: [String: Int]) async throws -> [ReadCardModel] {
	 guard !categoryProgress.isEmpty else { throw CardError.cardNoLeft }
	 
	 return try await firestore.fetchReads(
		categoryProgress: categoryProgress,
		languageCode: userDefaults.selectedLanguage.code,
		limitPerCategory: 10
	 )
  }
  
  /// Fetches and appends a prepared batch.
  func loadMoreReads(categoryProgress: [String: Int]) async throws {
	 let cards = try await fetchReadsCard(categoryProgress: categoryProgress)
	 
	 await MainActor.run {
		self.appendUniqueReads(cards)
	 }
  }
}

// MARK: - Display Mapping
private extension ReadsDeckManager {
  /// Combines Firestore cards with local CoreData interactions for UI.
  func makeDisplayReads(from reads: [ReadCardModel]) -> [DisplayReadCard] {
	 let interactionsById = Dictionary(uniqueKeysWithValues: readsInteractions.map { ($0.id, $0) })
	 
	 return reads.map { read in
		DisplayReadCard(
		  card: read,
		  status: status(for: read, interactionsById: interactionsById)
		)
	 }
  }
  
  /// Resolves visible UI status for a card.
  ///
  /// Priority matters: read beats archived, archived beats dismissed.
  func status(
	 for read: ReadCardModel,
	 interactionsById: [String: ReadInteractionModel]
  ) -> ReadCardDisplayStatus {
	 guard let interaction = interactionsById[read.id] else { return .fresh }
	 
	 if interaction.isRead { return .read }
	 if interaction.isSaved { return .archived }
	 if interaction.isSkipped { return .dismissed }
	 
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
	 
	 if let urlError = error as? URLError {
		switch urlError.code {
		case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost, .timedOut:
		  return .badInternetConnection
		case .dataNotAllowed:
		  return .cardNoLeft
		default:
		  return .somethingWentWrong
		}
	 }
	 
	 let nsError = error as NSError
	 if nsError.isFirestoreNoCardsError {
		return .cardNoLeft
	 }
	 
	 if nsError.domain == NSURLErrorDomain {
		return .badInternetConnection
	 }
	 
	 return .somethingWentWrong
  }
  
  /// Prints original error details before mapping.
  func printDeckError(_ error: Error) {
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
  }
}

// MARK: - Firestore Error Helpers
private extension NSError {
  /// Firestore sometimes reports an exhausted query/index as an NSError.
  /// These cases are treated as "no cards left" instead of a generic failure.
  var isFirestoreNoCardsError: Bool {
	 let message = [
		localizedDescription,
		localizedFailureReason,
		localizedRecoverySuggestion
	 ]
		.compactMap { $0 }
		.joined(separator: " ")
		.lowercased()
		.replacingOccurrences(of: "_", with: " ")
	 
	 if code == 11 { return true }
	 if message.contains("out of range") { return true }
	 if message.contains("outofrange") { return true }
	 if message.contains("out of index") { return true }
	 
	 return false
  }
}
