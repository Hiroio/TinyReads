//
//  ArchiveViewModel.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation

@MainActor
@Observable
final class ArchiveViewModel{
  var reads: [ReadCardModel] = []
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
  
  private let archiveManager = ArchiveManager.shared
  
  var state: ArchiveState {
	 archiveManager.state
  }
  
  init(){
  }
}

// MARK: Archive functions
extension ArchiveViewModel{
//  Load Manager
  func initialize() async {
	 do{
		try await archiveManager.initializeManager()
	 }catch{
		self.error = error
	 }
	 
	 syncCardsFromManager()
  }
  
//  SYNC CARDS WITH MANAGER USING STATE
  func syncCardsFromManager() {
	 self.reads = archiveManager.visibleCards
  }
  
//  Change state + syncronase cards
  func changeState(to state: ArchiveState) {
	 archiveManager.changeState(to: state)
	 syncCardsFromManager()
  }
  
  func onInteractionChange(_ id: String) {
	 archiveManager.applyInteractionChange(id)
	 syncCardsFromManager()
  }
  
//  FOR PREVIEW
  func preview(){
	 let reads = ReadCardModel.getForPreview()
	 self.reads = [reads]
  }
}
