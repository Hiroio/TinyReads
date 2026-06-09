//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation


@Observable
final class ReadsDeckManager{
  static let shared = ReadsDeckManager()
  
  var reads: [ReadCardModel] = []
  var readsInteractions: [ReadInteractionModel] = []
  
  let firestore: PublicReadsServiceProtocol
  let userDefaults: UserDefaultsManagerProtocol
  let coreDataManager = CoreDataService.shared
  
  init(
	 firestore: PublicReadsServiceProtocol = FireStoreService.shared,
	 userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared,
	 autoLoad: Bool = true
  ) {
	 self.firestore = firestore
	 self.userDefaults = userDefaultsManager
	 if autoLoad{
		loadInitialDeck()
	 }
  }
  
  
  var categories: [String] {
	 userDefaults.selectedCategories
//	 ReadCategories.allCases.map({$0.rawValue})
  }
  
  var activeReads: [ReadCardModel] {
	 reads.filter(\.isActive)
  }
  
  var freshDisplayReads: [DisplayReadCard] {
	 makeDisplayReads(from: reads).filter { $0.card.isActive && $0.status == .fresh }
  }
  
  var repeatDisplayReads: [DisplayReadCard] {
	 makeDisplayReads(from: reads)
  }
  
}

// MARK: - Deck Loading
extension ReadsDeckManager {
  // Initialize Deck at start
  func loadInitialDeck(){
	 fetchInteractionReads()
	 
	 let filteredInteractions = filterInteractions()
	 
	 Task{
		do{
		  try await loadMoreReads(categoryProgress: filteredInteractions)
		}catch{
		  print("Failed to load: \(error.localizedDescription)")
		}
	 }
  }
  
  // Load more cards from FireStore
  func loadMoreReads() async throws {
	 fetchInteractionReads()
	 try await loadMoreReads(categoryProgress: filterInteractions())
  }
  
  // Reload deck after selected categories changed
  func reloadForSelectedCategories() async throws {
	 await MainActor.run {
		self.reads = []
	 }
	 
	 try await loadMoreReads()
  }
}

// MARK: - FireStore
private extension ReadsDeckManager {
  // Fetch cards from FireStore
  func fetchReadsCard(categoryProgress: [String: Int]) async throws -> [ReadCardModel] {
	 guard !categories.isEmpty else { throw URLError(.dataNotAllowed)}
	 return try await firestore.fetchReads(
		categoryProgress: categoryProgress,
		languageCode: "uk",
		limitPerCategory: 10 	
	 )
  }
  
  // Append new cards to deck
  func loadMoreReads(categoryProgress: [String: Int]) async throws {
	 let cards = try await fetchReadsCard(categoryProgress: categoryProgress)
	 
	 await MainActor.run {
		self.appendUniqueReads(cards)
	 }
  }
}

// MARK: - Deck Actions
extension ReadsDeckManager {
  // Remove card from active deck
  func removeFromDeck(_ id: String) {
	 guard let index = reads.firstIndex(where: { $0.id == id }) else { return }
	 reads[index].isActive = false
  }
}

// MARK: - CoreData
extension ReadsDeckManager {
  // Fetch cards from CoreData
  func fetchInteractionReads() {
	 let entities = coreDataManager.fetchReadsEntity()
	 
	 self.readsInteractions = entities.compactMap({ try? ReadInteractionModel(entity: $0) })
  }
  
  /// saveCard (right swipe)
  @discardableResult
  func saveCard(_ card: ReadCardModel) -> Bool{
	 guard !readsInteractions.contains(where: {card.id == $0.id}) else { return true }
	 
	 var card = ReadInteractionModel(id: card.id, categoryId: card.categoryId, languageCode: card.languageCode, sortIndex: card.sortIndex)
	 card.savedAt = Date.now
	 card.isSaved = true
	 
	 let saved = coreDataManager.saveReadEntity(card)
	 if saved { fetchInteractionReads() }
	 return saved
  }
  
  /// dismissCard (left swipe)
  @discardableResult
  func dismissCard(_ card: ReadCardModel) -> Bool{
	 guard !coreDataManager.markDismissed(card.id) else { return true }
	 
	 var newCard = ReadInteractionModel(id: card.id, categoryId: card.categoryId, languageCode: card.languageCode, sortIndex: card.sortIndex)
	 newCard.isSkipped = true
	 newCard.skippedAt = .now
	 newCard.skipCount += 1
	 
	 let saved = coreDataManager.saveReadEntity(newCard)
	 if saved { fetchInteractionReads() }
	 return saved
  }
  
  // Prepare category progress for FireStore
  func filterInteractions() -> [String : Int] {
	 guard !categories.isEmpty else { return [:] }
	 
	 var result: [String : Int] = [:]
	 
		 for category in categories{
			result[category] = readsInteractions.getNextSortIndex(per: category)
		 }
	 
	 return result
  }
}

// MARK: - Display Cards
private extension ReadsDeckManager {
  // Build UI cards
  func makeDisplayReads(from reads: [ReadCardModel]) -> [DisplayReadCard] {
	 let interactionsById = Dictionary(uniqueKeysWithValues: readsInteractions.map { ($0.id, $0) })
	 
	 return reads.map { read in
		DisplayReadCard(
		  card: read,
		  status: status(for: read, interactionsById: interactionsById)
		)
	 }
  }
  
  // Resolve card status
  func status(
	 for read: ReadCardModel,
	 interactionsById: [String: ReadInteractionModel]
  ) -> ReadCardDisplayStatus {
	 guard let interaction = interactionsById[read.id] else { return .fresh }
	 
	 if interaction.isRead { return .read }
	 if interaction.isSkipped { return .dismissed }
	 if interaction.isSaved { return .archived }
	 
	 return .fresh
  }
  
  // Append cards without duplicates
  func appendUniqueReads(_ newReads: [ReadCardModel]) {
	 let existingIds = Set(reads.map(\.id))
	 reads.append(contentsOf: newReads.filter { !existingIds.contains($0.id) })
  }
}
