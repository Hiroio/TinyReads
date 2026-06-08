//
//  CardSliderViewModel.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation


@Observable
final class CardSliderViewModel{
  var cards: [ReadCardModel] = []
  var errorState: CardError?
  var loading: Bool = false
  
  
  let deckManager = ReadsDeckManager.shared
  init(){
	 fetchCards()
  }
  
  
  var dismissedCards: Int{
	 cards.filter({!$0.isActive}).count
  }
  
  var activeCards: [ReadCardModel] {
	 cards.filter({$0.isActive})
  }
  
}

// MARK: Functions
extension CardSliderViewModel{
//  fetch
  func fetchCards(){
	 loading = true
	 errorState = nil
	 guard deckManager.reads.isEmpty else {
		self.cards = deckManager.reads
		self.errorState = errorState(for: cards)
    self.loading = false
		return
	 }
	 
	 Task{
		do{
		  defer {loading = false}
		  
		  let cards = try await deckManager.fetchNextReadsCard()
		  
		  await MainActor.run {
			 self.cards = cards
			 self.errorState = self.errorState(for: cards)
		  }
		}catch{
		  await MainActor.run {
			 self.errorState = self.errorState(for: error)
			 self.loading = false
		  }
		}
	 }
  }
  
//  Reload cards
  func reloadCards(){
	 self.deckManager.loadInitialDeck()
  }
  
  // Left Swipe
  func onDismiss(_ id: String){
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index]
	 cards[index].isActive = false
	 deckManager.removeFromDeck(id)
	 deckManager.dismissCard(card)
  }
  
  // Right Swipe
  func onSave(_ id: String){
	 guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
	 
	 let card = cards[index]
	 cards[index].isActive = false
	 deckManager.removeFromDeck(id)
	 deckManager.saveCard(card)
  }

  private func errorState(for cards: [ReadCardModel]) -> CardError? {
	 guard cards.isEmpty else { return nil }
	 let lastSortIndex = deckManager.readsInteractions.map(\.sortIndex).max() ?? 0
	 return lastSortIndex > 100 ? .cardNoLeft : .somethingWentWrong
  }

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
