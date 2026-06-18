//
//  ProfileViewModel.swift
//  TinyReads
//
//  Created by user on 12.06.2026.
//

import Foundation

@Observable
final class ProfileViewModel{
  var interactionCards: [ReadInteractionModel] = []
  var favoriteCategory: String = "None"
  
  private let coreDataManager = CoreDataService.shared
  
  var readedCardsCount: Int {
	 interactionCards.count(where: { $0.isRead })
  }
  var skippedCardsCount: Int {
	 interactionCards.count(where: { $0.isSkipped })
  }
  
  var savedCardsCount: Int {
	 interactionCards.count(where: { $0.isSaved })
  }
  
  init() {
	 self.fetchCards()
	 self.favoriteCategory = self.getFavoriteCategory()
  }
  
  func fetchCards() {
	 let entities = self.coreDataManager.fetchReadsEntity()
	 
	 self.interactionCards = entities.compactMap({ try? ReadInteractionModel(entity: $0) })
  }
  
  func getFavoriteCategory() -> String{
	 let readCards = interactionCards.filter({ $0.isRead })
	 
	 let categories = readCards.map({ $0.categoryId })
	 let count = categories.reduce(into: [:]) { $0[$1, default: 0] += 1}
	 guard let favCategory = count.max(by: {$0.value < $1.value})?.key.capitalized, !favCategory.isEmpty else{
		return "None"
	 }
	 
	 return favCategory
  }
}
