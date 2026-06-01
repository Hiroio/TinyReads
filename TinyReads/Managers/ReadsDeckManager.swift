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
  }
  
  
  var categories: [String] {
	 userDefaults.selectedCategories
  }

  private var fetchCategoryIds: [String] {
    categories.isEmpty ? ReadCategories.allCases.map(\.rawValue) : categories
  }
}

// MARK: Functions
extension ReadsDeckManager{
  func fetchReadsCard() async throws -> [ReadCardModel]{
	 let cards = try await firestore.fetchReads(
    categoryIds: fetchCategoryIds,
    languageCode: "uk",
    limit: 100
   )
	 
	 await MainActor.run{
		self.reads = cards.shuffled()
	 }
	 return self.reads
  }

  func removeFromDeck(_ id: String) {
    guard let index = reads.firstIndex(where: { $0.id == id }) else { return }
    reads[index].isActive = false
  }
}

// MARK: CoreData
extension ReadsDeckManager{
  func fetchInteractionReads() {
	 let entities = coreDataManager.fetchReadsEntity()
	 
	 self.readsInteractions = entities.compactMap({ try? ReadInteractionModel(entity: $0) })
  }
  
  /// saveCard (right swipe)
  @discardableResult
  func saveCard(_ card: ReadCardModel) -> Bool{
	 var card = ReadInteractionModel(id: card.id, categoryId: card.categoryId, languageCode: card.languageCode)
	 card.savedAt = Date.now
	 card.isSaved = true
	 
	 return coreDataManager.saveReadEntity(card)
  }
  
  /// dismissCard (left swipe)
  @discardableResult
  func dismissCard(_ card: ReadCardModel) -> Bool{
	 guard !coreDataManager.markDismissed(card.id) else { return true }
	 
	 var newCard = ReadInteractionModel(id: card.id, categoryId: card.categoryId, languageCode: card.languageCode)
	 newCard.isSkipped = true
	 newCard.skippedAt = .now
	 newCard.skipCount += 1
	 
	 return coreDataManager.saveReadEntity(newCard)
  }
}
