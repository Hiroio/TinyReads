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
  let userDefaults = UserDefaultsManager.shared
  let coreDataManager = CoreDataService.shared
  
  init(firestore: PublicReadsServiceProtocol = FireStoreService.shared) {
	 self.firestore = firestore
	 loadInitialDeck()
  }
  
  
  var categories: [String] {
//	 userDefaults.selectedCategories
	 ReadCategories.allCases.map({$0.rawValue})
  }
  
}

//loadInitialDeck()
//saveCard(_ card)
//dismissCard(_ card)
//markRead(_ card)


// MARK: Functions
extension ReadsDeckManager{
//  Initialize Deck at start
  func loadInitialDeck(){
	 fetchInteractionReads()
	 
	 let filteredInteractions = filterInteractions()
	 
	 Task{
		do{
		  let reads = try await fetchReadsCard(categoryProgress: filteredInteractions)
		  
		  await MainActor.run{
			 self.reads = reads
		  }
		}catch{
		  print("Failed to load: \(error.localizedDescription)")
		}
	 }
  }
  
//  Fetch from FireStore
  func fetchReadsCard(categoryProgress: [String: Int]) async throws -> [ReadCardModel]{
	 let cards = try await firestore.fetchReads(
		categoryProgress: categoryProgress,
		languageCode: "uk",
		limitPerCategory: 100
	 )
	 
	 await MainActor.run{
		self.reads = cards
	 }
	 return self.reads
  }
  
//	Fetch next cards
  func fetchNextReadsCard() async throws -> [ReadCardModel] {
	 fetchInteractionReads()
	 return try await fetchReadsCard(categoryProgress: filterInteractions())
  }
  
//  For Dismiss
  func removeFromDeck(_ id: String) {
	 guard let index = reads.firstIndex(where: { $0.id == id }) else { return }
	 reads[index].isActive = false
  }
}

// MARK: CoreData
extension ReadsDeckManager{
//  Fetch cards from coreData
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
	 
	 return coreDataManager.saveReadEntity(card)
  }
  
  /// dismissCard (left swipe)
  @discardableResult
  func dismissCard(_ card: ReadCardModel) -> Bool{
	 guard !coreDataManager.markDismissed(card.id) else { return true }
	 
	 var newCard = ReadInteractionModel(id: card.id, categoryId: card.categoryId, languageCode: card.languageCode, sortIndex: card.sortIndex)
	 newCard.isSkipped = true
	 newCard.skippedAt = .now
	 newCard.skipCount += 1
	 
	 return coreDataManager.saveReadEntity(newCard)
  }
  
  func filterInteractions() -> [String : Int] {
	 guard !categories.isEmpty else { return [:] }
	 
	 var result = Dictionary(uniqueKeysWithValues: categories.map { ($0, 0) })
	 
	 guard !readsInteractions.isEmpty else { return result }
	 
	 readsInteractions.forEach { item in
		if let currentMax = result[item.categoryId] {
		  result[item.categoryId] = max(currentMax, item.sortIndex)
		}
	 }
	 
	 return result
  }
}
