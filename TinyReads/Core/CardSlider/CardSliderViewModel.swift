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
  var errorState: CardError? = .notReady
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

extension CardSliderViewModel{
  
	  func fetchCards(){
		 errorState = .notReady
		 guard deckManager.reads.isEmpty else {
			self.cards = deckManager.reads
      self.errorState = cards.isEmpty ? .notReady : nil
			return
		 }
	 
	 Task{
		defer { errorState = nil }
		do{
		  let cards = try await deckManager.fetchReadsCard()
		  
			  await MainActor.run {
				 self.cards = cards
          self.errorState = cards.isEmpty ? .notReady : nil
			  }
			}catch{
			  errorState = .notFound
		}
	 }
  }
  
  
	  func onDismiss(_ id: String){
		 deckManager.removeFromDeck(id)
     cards = deckManager.reads
	  }
}


enum CardError: Error, LocalizedError{
  case notFound, notReady
}
