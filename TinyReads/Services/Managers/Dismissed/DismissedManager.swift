//
//  DismissedManager.swift
//  TinyReads
//
//  Created by user on 10.06.2026.
//

import Foundation


@Observable
final class DismissedManager{
  static let shared = DismissedManager()
  
  var cards: [ReadCardModel] = []
  var cardsInteractions: [ReadInteractionModel] = []
  
  private let coreData = CoreDataService.shared
  private let fireStore = FireStoreService.shared
  init(){
	 
  }
  
  var dismissedIds: Set<String>{
	 Set(cardsInteractions.filter(\.isSkipped).map(\.id))
  }
  
  var dismissedCard: [ReadCardModel] {
	 cards.filter({item in dismissedIds.contains(where: { item.id == $0}) })
  }
}

extension DismissedManager{
  func initializeManager() async throws  {
	 self.cardsInteractions = fetchInteractionReads()
	 
	 print("Card Interaction: \(cardsInteractions.count)")
	 
	 let cards = try await fetchCards()
	 print("Fetched Cards \(cards.count)")
	 await MainActor.run {
		self.cards = cards
	 }
  }
  
  //  Fetching cards from coredata
  func fetchInteractionReads() -> [ReadInteractionModel]{
	 let cardEntities = coreData.fetchDismissed().compactMap({ try? ReadInteractionModel(entity: $0)})
	 return cardEntities
  }
  
  //  Fetching cards from fireStore
  func fetchCards() async throws -> [ReadCardModel]{
	 guard !cardsInteractions.isEmpty else { return [] }
	 
	 let ids = cardsInteractions.map { $0.id }
	 
	 return try await fireStore.fetchReads(ids: ids)
  }
  
  func applyInteractionChange(_ id: String) {
	 guard let newEntity = coreData.getSingleEntity(by: id) else { return }
	 
	 if let interaction = try? ReadInteractionModel(entity: newEntity){
		if let index = cardsInteractions.firstIndex(where: { $0.id == interaction.id }) {
		  cardsInteractions[index] = interaction
		} else {
		  cardsInteractions.append(interaction)
		}
	 }
  }
}
