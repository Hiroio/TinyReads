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
  var reads: [DisplayReadCard] = []
  var error: Error? = nil
  
  var searchText = "" {
			 didSet { restartSearchDebounce() }
		}
  private var searchTask: Task<Void, Never>? = nil
		
  var selectedCategory: String = "All" {
			 didSet { applyFilters() }
		}
  
  var filteredResults: [DisplayReadCard] = []
  
  private let archiveManager = ArchiveManager.shared
  private let userDefault = UserDefaultsManager.shared
  
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
	 
	 applyFilters()
  }
  
//  SYNC CARDS WITH MANAGER USING STATE
  func syncCardsFromManager() {
	 self.reads = archiveManager.visibleCards
  }
  
  func onInteractionChange(_ id: String) {
	 archiveManager.applyInteractionChange(id)
	 applyFilters()
  }

  func changeState(_ state: ArchiveState){
	 archiveManager.state = state
	 applyFilters()
  }

func applyFilters() {
  var results = archiveManager.visibleCards
  
  results = results.filter({ $0.card.languageCode == userDefault.selectedLanguage.code })
  
		  if selectedCategory != "All" {
			 results = results.filter { $0.card.categoryId == selectedCategory.lowercased() }
		  }
		  
		  if !searchText.isEmpty {
			 results = results.filter { $0.card.title.localizedCaseInsensitiveContains(searchText) }
		  }
		  
		  filteredResults = results
	 }
	 
	 private func restartSearchDebounce() {
		  searchTask?.cancel()
		  
		  searchTask = Task { @MainActor in
				do {
					 try await Task.sleep(for: .milliseconds(400))
					 applyFilters()
				} catch { }
		  }
	 }
}
