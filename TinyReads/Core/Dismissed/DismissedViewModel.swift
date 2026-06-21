//
//  DismissedViewModel.swift
//  TinyReads
//
//  Created by user on 10.06.2026.
//

import Foundation

@MainActor
@Observable
final class DismissedViewModel{
  var reads: [ReadCardModel] = []
  var error: Error? = nil
  
  private let dismissedManager = DismissedManager.shared
  
  
}


extension DismissedViewModel{
  //  Load Manager
	 func initialize() async {
		do{
		  try await dismissedManager.initializeManager()
		}catch{
		  self.error = error
		}
		
		syncCardsFromManager()
	 }
	 
  //  SYNC CARDS WITH MANAGER USING STATE
	 func syncCardsFromManager() {
		self.reads = dismissedManager.dismissedCard
	 }
	 
	 func onInteractionChange(_ id: String) {
		dismissedManager.applyInteractionChange(id)
		syncCardsFromManager()
	 }
}
