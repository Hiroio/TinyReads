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
  private let loadMoreThreshold = 1
  
  init(){
	 fetchCards()
  }
  
  var dismissedCards: Int{
	 cards.filter({$0.status != ReadCardDisplayStatus.fresh}).count
  }
  
  var fetchIsActive: Bool {
	 deckManager.fetchIsActive
  }
  
  //  checking selected Categories for showing errors
  var hasSelectedCategories: Bool {
	 !deckManager.categories.isEmpty
  }
  
  var errorState: CardError? {
	 guard cards.isEmpty else { return nil }
	 if let errorState = deckManager.errorState { return errorState }
	 guard hasSelectedCategories else { return .noCategories }
	 return .cardNoLeft
  }
  
}

// MARK: - Deck Loading
extension CardSliderViewModel {
  // Fetch cards
  func fetchCards() {
	 guard hasSelectedCategories else {
		cards = []
		return
	 }
	 /// checking if deckManager has cards, if it's we getting this cards and fetch next 10 if needed
	 guard deckManager.reads.isEmpty else {
		syncCardsFromDeck()
		keepDeckAliveIfNeeded()
		return
	 }
	 
	 Task {
		await deckManager.loadMoreReads()
		await MainActor.run {
		  self.syncCardsFromDeck()
		  self.keepDeckAliveIfNeeded()
		}
	 }
  }
  
  // Reload cards
  func reloadCards() async {
	 self.cards = []
	 
	 guard hasSelectedCategories else {
		return
	 }
	 
	 await deckManager.reloadForSelectedCategories()
	 
	 await MainActor.run {
		self.syncCardsFromDeck()
	 }
  }
  
  
  // Sync UI cards from manager
  private func syncCardsFromDeck() {
	 switch deckMode{
	 case .freshOnly:
		cards = deckManager.freshDisplayReads
	 case .repeatOld:
		cards = deckManager.repeatDisplayReads.filter({$0.status != .fresh}).sorted(by: {$0.card.sortIndex < $1.card.sortIndex})
	 }
  }
  
  
  // Load next batch when fresh deck is almost empty
  @discardableResult
  private func keepDeckAliveIfNeeded() -> Bool {
	 guard deckMode == .freshOnly else { return false }
	 guard hasSelectedCategories else { return false }
	 guard !fetchIsActive else { return false }
	 guard cards.count <= loadMoreThreshold else { return false }
	 
	 Task {
		await deckManager.loadMoreReads()
		
		await MainActor.run {
		  self.syncCardsFromDeck()
		}
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
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.dismissCard(card)
	 userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex, language: LanguageEnum(rawValue: card.languageCode))
	 keepDeckAliveIfNeeded()
  }
  
  // Right Swipe
  func onSave(_ id: String) {
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index].card
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.saveCard(card)
	 userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex, language: LanguageEnum(rawValue: card.languageCode))
	 keepDeckAliveIfNeeded()
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
	 syncCardsFromDeck()
	 keepDeckAliveIfNeeded()
  }
}



// MARK: - UI Interactions/Helpers.
extension CardSliderViewModel{
  //  CHANGE MOD OF CARDS
  func changeDeckMode() {
	 self.deckMode = deckMode == .freshOnly ? .repeatOld : .freshOnly
	 
	 syncCardsFromDeck()
	 keepDeckAliveIfNeeded()
  }
  
  
  func reshuffleViewed() {
	 deckMode = .repeatOld
	 syncCardsFromDeck()
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
