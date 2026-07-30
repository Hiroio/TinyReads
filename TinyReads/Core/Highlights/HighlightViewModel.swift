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
  
  var searchText: String = ""
  var widgetState: Bool = false
  var deleteState: Bool = false
  
  private let highlightManager = HighlightManager.shared
  
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
	 withObservationTracking {
		_ = highlightManager.highlights
	 } onChange: {
		Task{ @MainActor  [weak self] in
		  guard let self else { return }
		  print("Changedd Highlight")
		  self.highlights = self.highlightManager.highlights
		  
		  self.startTrackingHiglights()
		}
	 }

  }
}
