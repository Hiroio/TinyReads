//
//  CardSliderViewModel.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation


@Observable
final class CardSliderViewModel{
  var cards: [DisplayReadCard] = []
  var deckMode: DeckMode = .freshOnly
  
  
  let deckManager = ReadsDeckManager.shared
  private let userDefaultManager = UserDefaultsManager.shared
  private let loadMoreThreshold = 2
  
  init(){
	 startTracking()
  }
  
  var fetchIsActive: Bool {
	 deckManager.fetchIsActive
  }
  var errorState: CardError? {
	 deckManager.errorState
  }
  
  var freshDisplayReads: [DisplayReadCard] = []
  
  var repeatDisplayReads: [DisplayReadCard] = []
  
}

// MARK: - Deck Loading
extension CardSliderViewModel {
  // Fetch cards
  func fetchCards() {
	 Task {
		await deckManager.fetchFreshReads()
	 }
  }
  
  // Reload cards
  func reloadCards() async {
	 self.cards = []
	 await deckManager.reloadForSelectedCategories()
  }
  
  
  // Refresh Active Status for Viewed
  func refreshActiveStatus() {
	 deckManager.refreshActiveStatus()
	 self.cards = deckManager.displayCards
  }
  
  
  // Load next batch only after swipe actions when fresh deck reaches the threshold
  @discardableResult
  private func keepDeckAliveAfterSwipe() -> Bool {
	 guard deckMode == .freshOnly else { return false }
	 guard deckManager.errorState == nil else { return false }
	 guard !fetchIsActive else { return false }
	 guard freshDisplayReads.count <= loadMoreThreshold else { return false }
	 
	 Task {
		await deckManager.fetchFreshReads()
	 }
	 
	 return true
  }
}



// MARK: - Card Actions
extension CardSliderViewModel {
  // Left Swipe
  func onDismiss(_ id: String) {
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index].card
	 if cards[index].status == .fresh{
		userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex, language: LanguageEnum(rawValue: card.languageCode))
		keepDeckAliveAfterSwipe()
	 }
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.dismissCard(card)
	 
  }
  
  // Right Swipe
  func onSave(_ id: String) {
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 let card = cards[index].card
	 if cards[index].status == .fresh{
		userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex, language: LanguageEnum(rawValue: card.languageCode))
		trackCategoryCompletionIfNeeded(card: card)
		
		keepDeckAliveAfterSwipe()
	 }
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.saveCard(card)
  }
  
  func articleRoute(for id: String) -> ArticleRoute? {
	 guard let displayCard = cards.first(where: { $0.id == id }) else { return nil }
	 
	 return ArticleRoute(
		article: displayCard.card,
		onInteractionChanged: { [weak self] in
		  self?.onArticleInteractionChange(id)
		},
		isAbleToInteract: displayCard.status
	 )
  }
  
  func onArticleInteractionChange(_ id: String) {
	 deckManager.applyInteractionChange(id)
	 deckManager.removeFromDeck(id)
  }
}



// MARK: - UI Interactions/Helpers.
extension CardSliderViewModel{
  //  CHANGE MOD OF CARDS
  func changeDeckMode() {
	 self.deckMode = deckMode == .freshOnly ? .repeatOld : .freshOnly
  }
  
  // Check if all cards readed.
  func checkIfCategoryLimitsNotReached() -> Bool{
	 for i in deckManager.categories{
		if let category = ReadCategories(rawValue: i){
		  if userDefaultManager.getCategoryReadedCount(for: category) != category.limit{
			 return true
		  }
		}
	 }
	 
	 return false
  }
}




extension CardSliderViewModel{
  //  For Navigation
  func openArticle(_ id: String) {
	 guard let route = self.articleRoute(for: id) else { return }
	 NavigationManager.shared.article = route
  }
  
  //  Subscribe for reads in deckManager
  func startTracking() {
	 withObservationTracking {
		_ = deckManager.reads
	 } onChange: {
		
		DispatchQueue.main.async { [weak self] in
		  guard let self = self else { return }
		  
		  self.cards = deckManager.displayCards
		  self.repeatDisplayReads = cards.filter{ $0.status != .fresh && $0.status != .read && $0.card.isActive }.sorted{ $0.card.sortIndex < $1.card.sortIndex }
		  self.freshDisplayReads = cards.filter { $0.card.isActive && $0.status == .fresh }.sorted { $0.card.sortIndex < $1.card.sortIndex }
		  self.startTracking()
		}
	 }
  }
  
  
  
//  For Analytics
  private func trackCategoryCompletionIfNeeded(card: ReadCardModel){
	 guard let category = ReadCategories(rawValue: card.categoryId) else { return }
	 guard card.sortIndex == category.limit else { return }
	 
	 AnalyticsManager.shared.categoryCompleted(categoryId: category.rawValue, language: card.languageCode)
  }
}
