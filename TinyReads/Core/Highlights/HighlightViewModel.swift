//
//  HighlightViewModel.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import Foundation
import WidgetKit

@MainActor
@Observable
final class HighlightViewModel{
  var highlights: [HighlightModel] = []
  var searchResult: [HighlightModel] = []
  var unSelectedFilterCategories: [ReadCategories] = []
  
  var searchText: String = ""{
	 didSet{
		restartSearchDebounce()
	 }
  }
  
  init(){
	 startTrackingHiglights()
  }
  
  var widgetState: Bool = false
  var deleteState: Bool = false
  
  private var searchTask: Task<Void, Never>? = nil
  
  private let highlightManager = HighlightManager.shared
  private let userDefault = UserDefaultsManager.shared
  
  
  var availableHighlightsCategories: [ReadCategories] {
	 let presentCategoryIds = Set(highlights.map({ $0.categoryId }))
	 return ReadCategories.allCases.filter({ presentCategoryIds.contains($0.rawValue) })
  }
  
}




extension HighlightViewModel{
  
  func deleteHighlight(highlight: HighlightModel) {
	 if highlightManager.deleteHighlight(id: highlight.id){
		NavigationManager.shared.popUpState = .deleted
		WidgetCenter.shared.reloadTimelines(ofKind: "Highlight Widget")
	 }else{
		NavigationManager.shared.popUpState = .error
	 }
  }
  
  
  func activateForWidget(highlight: HighlightModel) {
	 var highlightToEdit = highlight
	 highlightToEdit.widgetIsActive = !highlight.widgetIsActive
	 if highlightManager.editHiglight(highlight: highlightToEdit){
		WidgetCenter.shared.reloadTimelines(ofKind: "Highlight Widget")
	 }else{
		NavigationManager.shared.popUpState = .error
	 }
  }
  
  
  
  func startTrackingHiglights(){
	 self.highlights = highlightManager.highlights
	 applyFilters()
	 withObservationTracking {
		_ = highlightManager.highlights
	 } onChange: {
		Task{ @MainActor  [weak self] in
		  guard let self else { return }
		  self.startTrackingHiglights()
		}
	 }
	 
  }
  
  
  func handleFilterCategory(category: ReadCategories){
	 if unSelectedFilterCategories.contains(category){
		unSelectedFilterCategories.removeAll(where: {$0 == category})
	 }else{
		unSelectedFilterCategories.append(category)
	 }
	 applyFilters()
  }
}

// Search
extension HighlightViewModel{
  func applyFilters() {
	 var results = highlightManager.highlights
	 
	 if !unSelectedFilterCategories.isEmpty{
		results = results.filter({ higlight in !unSelectedFilterCategories.contains(where: { $0.rawValue == higlight.categoryId })})
	 }
	 
	 if !searchText.isEmpty {
		results = results.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
	 }
	 
	 searchResult = results
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
