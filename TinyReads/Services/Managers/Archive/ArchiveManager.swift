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
  
  var cards: [ReadCardModel] = []
  var cardsInteractions: [ReadInteractionModel] = []
  var state: ArchiveState = .saved
  
  
  private let coreData = CoreDataService.shared
  private let fireStore = FireStoreService.shared
  
  
  var readCards: [ReadInteractionModel]{
	 cardsInteractions.filter({ $0.isRead })
  }
  
  var savedCards: [ReadInteractionModel]{
	 cardsInteractions.filter({ $0.isSaved })
  }
  
  var visibleCards: [ReadCardModel] {
	 filterCards(state: state)
  }
}


extension ArchiveManager{
  
//   Initialize start of manager
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
	 let cardEntities = coreData.fetchSavedOrReaded().compactMap({ try? ReadInteractionModel(entity: $0)})
	 return cardEntities
  }
  
  //  Fetching cards from fireStore
  func fetchCards() async throws -> [ReadCardModel]{
	 guard !cardsInteractions.isEmpty else { return [] }
	 
	 let ids = cardsInteractions.map { $0.id }
	 
	 return try await fireStore.fetchReads(ids: ids)
  }
  
//  Change archive state
  func changeState(to newState: ArchiveState) {
	 guard state != newState else { return }
	 state = newState
  }
  
//  Filter cards depend on state
  func filterCards(state: ArchiveState) -> [ReadCardModel] {
	 return switch state {
	 case .saved:
		filterCards(with: savedCards)
	 case .read:
		filterCards(with: readCards)
	 }
  }
  
//  Filter cards by interaction ids
  private func filterCards(with interactions: [ReadInteractionModel]) -> [ReadCardModel] {
	 let ids = Set(interactions.map(\.id))
	 return cards.filter { ids.contains($0.id) }
  }
  
}
