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
	 let minutes = wordsReadCount / 150

	 //  "min"/"h" були захардкоджені англійською. Duration форматує одиниці сам,
	 //  а locale береться з вибору в застосунку, а не з мови пристрою.
	 let locale = Locale(identifier: UserDefaultsManager.shared.selectedLanguage.code)

	 return Duration.seconds(minutes * 60)
		.formatted(.units(allowed: [.hours, .minutes], width: .abbreviated).locale(locale))
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
