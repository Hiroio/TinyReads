//
//  HighlightActionViewModel.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import Foundation


@Observable
final class HighlightActionViewModel{
  var highlight: HighlightModel
  var text: String = ""
  var state: HighlightScreenState
  var note: Bool = false
  
  init(highlight: HighlightModel, state: HighlightScreenState){
	 self.highlight = highlight
	 self.text = highlight.text
	 self.state = state
  }
  
  private let highlightManager = HighlightManager.shared
  
  
  var actionBtnText: String{
	 if state.isCreate {
		return "Create"
	 }else if note{
		return "Save"
	 }
	 return ""
  }
  
  
}


extension HighlightActionViewModel{
//  MARK: Actions
//  Handle action Btn Press
  func actionBtn(){
	 if state.isCreate{
		if createHighlight() {
		  showAnimation(.created)
		}else{
		  showAnimation(.error)
		}
		NavigationManager.shared.highlight = nil
	 }else{
		if editHighlight() {
		  showAnimation(.created)
		}else{
		  showAnimation(.error)
		}
	 }
  }
  
  
//  ------- Creation
  private func createHighlight() -> Bool {
	 guard highlight.text.isEmpty == false else { return false }
	 
	 return highlightManager.createHighlight(highlight: highlight)

  }
  
//  ------ Edit
  private func editHighlight() -> Bool {
	 return highlightManager.editHiglight(highlight: highlight)
	 
  }
  
  private func showAnimation(_ state: SmallPopUpEnum){
	 NavigationManager.shared.popUpState = state
  }
}



enum HighlightScreenState: Identifiable, Equatable{
  case idle(HighlightModel), create(HighlightModel), edit(HighlightModel)
  
  var id: String{
	 switch self {
	 case .idle(_):
		"Idle"
	 case .create(_):
		"Create"
	 case .edit(_):
		"Edit"
	 }
  }
  
  var value: HighlightModel{
	 switch self {
	 case .idle(let highlightModel):
		highlightModel
	 case .create(let highlightModel):
		highlightModel
	 case .edit(let highlightModel):
		highlightModel
	 }
  }
  
  
  var isIdle: Bool {
	 if case .idle = self { true } else { false }
  }
  
  var isCreate: Bool{
	 if case .create = self { true } else { false }
  }
}
