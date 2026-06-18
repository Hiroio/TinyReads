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
  var errorState: CardError?
  var fetchIsActive: Bool = false
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
  
  var hasSelectedCategories: Bool {
	 !deckManager.categories.isEmpty
  }
  
}

// MARK: - Deck Loading
extension CardSliderViewModel {
  // Fetch cards
  func fetchCards() {
	 fetchIsActive = true
	 errorState = nil
	 
	 guard hasSelectedCategories else {
		cards = []
		errorState = .noCategories
		fetchIsActive = false
		return
	 }
	 
	 guard deckManager.reads.isEmpty else {
		syncCardsFromDeck()
		self.fetchIsActive = false
		if !keepDeckAliveIfNeeded(), !fetchIsActive {
		  self.errorState = errorState(for: cards)
		}
		return
	 }
	 
	 Task{
		do{
		  try await deckManager.loadMoreReads()
		  
		  await MainActor.run {
			 self.syncCardsFromDeck()
			 self.fetchIsActive = false
			 if !self.keepDeckAliveIfNeeded(), !self.fetchIsActive {
				self.errorState = self.errorState(for: self.cards)
			 }
		  }
		}catch{
		  await MainActor.run {
			 self.errorState = self.errorState(for: error)
			 self.fetchIsActive = false
		  }
		}
	 }
  }
  
  // Reload cards
  func reloadCards() async {
	 fetchIsActive = true
	 errorState = nil
	 self.cards = []
	 
	 guard hasSelectedCategories else {
		self.errorState = .noCategories
		self.fetchIsActive = false
		return
	 }
	 
	 do{
		try await self.deckManager.reloadForSelectedCategories()
		
		await MainActor.run {
		  self.syncCardsFromDeck()
		  self.errorState = self.errorState(for: self.cards)
		  self.fetchIsActive = false
		}
	 }catch{
		await MainActor.run {
		  self.errorState = self.errorState(for: error)
		  self.fetchIsActive = false
		}
	 }
	 
  }
  
  // Sync UI cards from manager
  private func syncCardsFromDeck() {
	 switch deckMode{
	 case .freshOnly:
		cards = deckManager.freshDisplayReads
	 case .repeatOld:
		cards = deckManager.repeatDisplayReads.sorted(by: {$0.card.sortIndex < $1.card.sortIndex})
	 }
  }
  
  func changeDeckMode() {
	 self.deckMode = deckMode == .freshOnly ? .repeatOld : .freshOnly
	 
	 syncCardsFromDeck()
	 if !keepDeckAliveIfNeeded(), !fetchIsActive {
		errorState = errorState(for: cards)
	 }
  }
  
  func reshuffleViewed() {
	 deckMode = .repeatOld
	 syncCardsFromDeck()
	 errorState = errorState(for: cards)
  }
  
  // Load next batch when fresh deck is almost empty
  @discardableResult
  private func keepDeckAliveIfNeeded() -> Bool {
	 guard deckMode == .freshOnly else { return false }
	 guard hasSelectedCategories else { return false }
	 guard !fetchIsActive else { return false }
	 guard cards.count <= loadMoreThreshold else { return false }
	 
	 fetchIsActive = true
	 errorState = nil
	 
	 Task {
		do {
		  try await deckManager.loadMoreReads()
		  
		  await MainActor.run {
			 self.syncCardsFromDeck()
			 self.fetchIsActive = false
			 self.errorState = self.errorState(for: self.cards)
		  }
		} catch {
		  await MainActor.run {
			 self.fetchIsActive = false
			 self.errorState = self.cards.isEmpty ? self.errorState(for: error) : nil
		  }
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
	 userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex)
	 if !keepDeckAliveIfNeeded(), !fetchIsActive {
		errorState = errorState(for: cards)
	 }
  }
  
  // Right Swipe
  func onSave(_ id: String) {
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index].card
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.saveCard(card)
	 userDefaultManager.setCategoryReadedCount(for: card.categoryId, index: card.sortIndex)
	 if !keepDeckAliveIfNeeded(), !fetchIsActive {
		errorState = errorState(for: cards)
	 }
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
	 if !keepDeckAliveIfNeeded(), !fetchIsActive {
		errorState = errorState(for: cards)
	 }
  }
}

// MARK: - Error Handling
private extension CardSliderViewModel {
  // Get empty deck error
  private func errorState(for cards: [DisplayReadCard]) -> CardError? {
	 guard cards.isEmpty else { return nil }
	 let lastSortIndex = deckManager.readsInteractions.map(\.sortIndex).max() ?? 0
	 return lastSortIndex > 100 ? .cardNoLeft : .somethingWentWrong
  }

  // Get fetch error
  private func errorState(for error: Error) -> CardError {
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
	 if nsError.domain == NSURLErrorDomain {
		return .badInternetConnection
	 }

	 return .somethingWentWrong
  }
}
