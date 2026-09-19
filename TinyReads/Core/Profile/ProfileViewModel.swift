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
  
  var wordsReadCount: Int {
	 interactionCards.filter({ $0.isRead }).map({$0.wordCount}).reduce(0, +)
  }
  
  var readTime: String{
	 let time = wordsReadCount / 150
	 let hours = time / 60
	 if hours == 0{
		return "\(time) min"
	 }
	 return "\(hours)h \(time % 60)m"
  }
  
  var firstCardDate: Date?{
	 let dates = interactionCards.compactMap({ [$0.readAt, $0.savedAt, $0.skippedAt]}).flatMap({$0}).compactMap({$0})
		.min()
	 return dates
  }
  
//  MARK: INIT
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
	 guard let favCategory = count.max(by: {$0.value < $1.value})?.key, !favCategory.isEmpty else{
		return "None"
	 }
	 
	 return favCategory
  }
}
