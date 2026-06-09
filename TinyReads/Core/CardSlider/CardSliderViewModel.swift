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
  var loading: Bool = false
  var deckMode: DeckMode = .freshOnly
  
  let deckManager = ReadsDeckManager.shared
  init(){
	 fetchCards()
  }
  
  var dismissedCards: Int{
	 cards.filter({$0.status != ReadCardDisplayStatus.fresh}).count
  }
  
}

// MARK: - Deck Loading
extension CardSliderViewModel {
  // Fetch cards
  func fetchCards() {
	 loading = true
	 errorState = nil
	 guard deckManager.reads.isEmpty else {
		syncCardsFromDeck()
		self.errorState = errorState(for: cards)
		self.loading = false
		return
	 }
	 
	 Task{
		do{
		  try await deckManager.loadMoreReads()
		  
		  await MainActor.run {
			 self.syncCardsFromDeck()
			 self.errorState = self.errorState(for: self.cards)
			 self.loading = false
		  }
		}catch{
		  await MainActor.run {
			 self.errorState = self.errorState(for: error)
			 self.loading = false
		  }
		}
	 }
  }
  
  // Reload cards
  func reloadCards() async {
	 loading = true
	 errorState = nil
	 self.cards = []
	 
	 do{
		try await self.deckManager.reloadForSelectedCategories()
		
		await MainActor.run {
		  self.syncCardsFromDeck()
		  self.errorState = self.errorState(for: self.cards)
		  self.loading = false
		}
	 }catch{
		await MainActor.run {
		  self.errorState = self.errorState(for: error)
		  self.loading = false
		}
	 }
	 
  }
  
  // Sync UI cards from manager
  private func syncCardsFromDeck() {
	 switch deckMode{
	 case .freshOnly:
		cards = deckManager.freshDisplayReads
	 case .repeatOld:
		cards = deckManager.repeatDisplayReads.shuffled()
	 }
  }
  
  func changeDeckMode() {
	 self.deckMode = deckMode == .freshOnly ? .repeatOld : .freshOnly
	 
	 syncCardsFromDeck()
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
  }
  
  // Right Swipe
  func onSave(_ id: String) {
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index].card
	 cards.remove(at: index)
	 deckManager.removeFromDeck(id)
	 deckManager.saveCard(card)
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


enum CardError: Error, LocalizedError{
  case badInternetConnection
  case somethingWentWrong
  case cardNoLeft

  var title: String {
	 switch self {
	 case .badInternetConnection:
		"Bad internet connection"
	 case .somethingWentWrong:
		"Something went wrong"
	 case .cardNoLeft:
		"No cards left"
	 }
  }

  var subtitle: String {
	 switch self {
	 case .badInternetConnection:
		"Check your connection and try again."
	 case .somethingWentWrong:
		"We could not prepare your reads right now."
	 case .cardNoLeft:
		"You reached the end of this shelf for now."
	 }
  }

  var imageName: String {
	 switch self {
	 case .badInternetConnection:
		"BadInternetConnection"
	 case .somethingWentWrong:
		"SomethingWentWrong"
	 case .cardNoLeft:
		"CardNoLeft"
	 }
  }

  var buttonTitle: String {
	 switch self {
	 case .badInternetConnection, .somethingWentWrong:
		"Try again"
	 case .cardNoLeft:
		"Select Category"
	 }
  }
}



enum DeckMode {
	 case freshOnly
	 case repeatOld
  
  var image: String {
	 switch self {
	 case .freshOnly:
		"newspaper"
	 case .repeatOld:
		"xmark.bin"
	 }
  }
}
