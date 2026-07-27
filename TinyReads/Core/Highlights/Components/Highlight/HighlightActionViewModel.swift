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
  var warningText: String = ""
  
  init(highlight: HighlightModel, state: HighlightScreenState){
	 self.highlight = highlight
	 self.text = highlight.text
	 self.state = state
  }
  
  private let highlightManager = HighlightManager.shared
  
  
  var actionBtnText: HighlightActionCode?{
	 if state.isCreate {
		return HighlightActionCode.create
	 }else if highlight.note != state.value.note{
		return HighlightActionCode.edit
	 }
	 return nil
  }
  
  
  var noteActionText: String{
	 if highlight.note.isEmpty{
		"Add Note"
	 }else{
		"Note"
	 }
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
  
  
//  ------ Utility
//  Show Animation
  private func showAnimation(_ state: SmallPopUpEnum){
	 NavigationManager.shared.popUpState = state
  }
  
//  Exit Action
  func exitAction(){
	 if let actionBtnText{
		warningText = actionBtnText.warningText
	 }else{
		NavigationManager.shared.highlight = nil
	 }
  }
  
//  Navigation Article
  func navigateToArticle(){
	 Task { @MainActor [weak self] in
		guard let self else { return }
		guard let article = try? await FireStoreService.shared.fetchReads(ids: [highlight.originalId]).first else { return }

		NavigationManager.shared.highlight = nil
		NavigationManager.shared.secondary = nil
		NavigationManager.shared.article = ArticleRoute(
		  article: article,
		  onInteractionChanged: {},
		  isAbleToInteract: .read
		)
	 }
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



enum HighlightActionCode{
  case create, edit
  
  var actionBtn: String {
	 switch self {
	 case .create:
		"Create"
	 case .edit:
		"Save"
	 }
  }
  
  var warningText: String{
	 switch self {
	 case .create:
		"If you leave now, everything you've written wont be saved."
	 case .edit:
		"Your changes haven't been saved. \nIf you leave now, your notes changes will be lost."
	 }
  }
}
