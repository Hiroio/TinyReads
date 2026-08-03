//
//  ArchiveManager.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation

@Observable
final class ArchiveManager{
  static let shared = ArchiveManager()
  
  var cards: [DisplayReadCard] = []
  var cardsInteractions: [ReadInteractionModel] = []
  var state: ArchiveState = .all
  
  
  private let coreData = CoreDataService.shared
  private let fireStore = FireStoreService.shared
  
  
  var readCards: [ReadInteractionModel]{
	 cardsInteractions.filter({ $0.isRead && $0.isSkipped == false })
  }
  
  var savedCards: [ReadInteractionModel]{
	 cardsInteractions.filter({ $0.isSaved && $0.isRead == false && $0.isSkipped == false })
  }
  
  var dismissedCards: [ReadInteractionModel]{
	 cardsInteractions.filter({ $0.isSkipped })
  }
  
  var visibleCards: [DisplayReadCard] {
	 filterCards(state: state)
  }
}


extension ArchiveManager{
  
//   Initialize start of manager
  func initializeManager() async throws  {
	 let interactionsCards = fetchInteractionReads()
	 self.cardsInteractions = interactionsCards
	 let cards = try await fetchCards()
	 
	 let displayCards = creatingDisplayCards(interactions: interactionsCards, cards: cards)
	 
	 await MainActor.run {
		self.cards = displayCards
	 }
  }
  
  //  Fetching cards from coredata
  func fetchInteractionReads() -> [ReadInteractionModel]{
	 let cardEntities = coreData.fetchReadsEntity().compactMap({ try? ReadInteractionModel(entity: $0)})
	 return cardEntities
  }
  
  //  Fetching cards from fireStore
  func fetchCards() async throws -> [ReadCardModel]{
	 guard !cardsInteractions.isEmpty else { return [] }
	 
	 let ids = cardsInteractions.map { $0.id }
	 
	 return try await fireStore.fetchReads(ids: ids)
  }
  
  func creatingDisplayCards(interactions: [ReadInteractionModel], cards: [ReadCardModel]) -> [DisplayReadCard]{
	 return cards.compactMap { card in
		if let index = interactions.firstIndex(where: {$0.id == card.id}) {
		  let display = DisplayReadCard(card: card, interaction: interactions[index])
		  return display
		}
		return nil
	 }
  }
  
//  Change archive state
  func changeState(to newState: ArchiveState) {
	 guard state != newState else { return }
	 state = newState
  }
  
//  Filter cards depend on state
  func filterCards(state: ArchiveState) -> [DisplayReadCard] {
	 return switch state {
	 case .all:
		cards
	 case .dismissed:
		cards.filter({$0.status == .dismissed})
	 case .saved:
		cards.filter({$0.status == .archived})
	 case .read:
		cards.filter({$0.status == .read})
	 }
  }
  
//  Change Interaction
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
