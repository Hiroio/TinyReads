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
  
  var searchText = "" {
			 didSet { restartSearchDebounce() }
		}
  private var searchTask: Task<Void, Never>? = nil
		
  var selectedCategory: String = "All" {
			 didSet { applyFilters() }
		}
  
  var filteredResults: [ReadCardModel] = []
  
  private let dismissedManager = DismissedManager.shared
  private let userDefault = UserDefaultsManager.shared
  
}


extension DismissedViewModel{
  //  Load Manager
	 func initialize() async {
		do{
		  try await dismissedManager.initializeManager()
		}catch{
		  self.error = error
		}
		
		applyFilters()
	 }
	 
  //  SYNC CARDS WITH MANAGER USING STATE
	 func syncCardsFromManager() {
		self.reads = dismissedManager.dismissedCard
	 }
	 
	 func onInteractionChange(_ id: String) {
		dismissedManager.applyInteractionChange(id)
		applyFilters()
	 }
  
  
  func applyFilters() {
	 var results = dismissedManager.cards
	 
	 results = results.filter({ $0.languageCode == userDefault.selectedLanguage.code })
	 
			 if selectedCategory != "All" {
				results = results.filter { $0.categoryId == selectedCategory.lowercased() }
			 }
			 
			 if !searchText.isEmpty {
				  results = results.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
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
