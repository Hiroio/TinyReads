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
  var reads: [ReadCardModel] = [ReadCardModel.getForPreview()]
  var error: Error? = nil
  
  var selectedFilter = "All"
  
  var filetredReads: [ReadCardModel]{
	 switch selectedFilter{
	 case "All":
		return reads
	 default:
		return reads.filter({ $0.categoryId == selectedFilter.lowercased()})
	 }
  }
  
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
