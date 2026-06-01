//
//  CardSliderViewModel.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation


@Observable
class CardSliderViewModel{
  var cards: [ReadCardModel] = []
  var errorState: CardError? = .notReady
  
  init(){
	 uploadTestCards()
  }
  
  
  var dismissedCards: Int{
	 cards.filter({!$0.isActive}).count
  }

  var activeCards: [ReadCardModel] {
	 cards.filter({$0.isActive})
  }
  
}

extension CardSliderViewModel{
  func uploadTestCards(){
	 guard let url = Bundle.main.url(forResource: "Ukraine_Philosophy", withExtension: "json") else {
		  return
	 }
	 
	 do {
		let data = try Data(contentsOf: url)
		let decodedData = try JSONDecoder().decode(RootReads.self, from: data)
		self.cards = decodedData.reads
		self.errorState = nil
	 }catch{
		errorState = .notFound
	 }
  }
  
  
  func onDismiss(_ id: String){
	 guard let index = cards.firstIndex(where: {$0.id == id}) else { return }
	 
	 cards[index].isActive = false
  }
}


enum CardError: Error, LocalizedError{
  case notFound, notReady
}
