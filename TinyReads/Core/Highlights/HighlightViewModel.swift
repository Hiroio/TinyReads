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
  
  
  var searchText: String = ""{
	 didSet{
		restartSearchDebounce()
	 }
  }
  var widgetState: Bool = false
  var deleteState: Bool = false

  private var searchTask: Task<Void, Never>? = nil

  private let highlightManager = HighlightManager.shared
  private let userDefault = UserDefaultsManager.shared

  init(){
	 startTrackingHiglights()
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
}

// Search
extension HighlightViewModel{
  func applyFilters() {
	 var results = highlightManager.highlights
			 
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
