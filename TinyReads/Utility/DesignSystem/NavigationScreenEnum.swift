//
//  NavigationScreenEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation

enum SecondaryAppScreen {
  case profile
  case category
  case highlight
  case archive
  case store
}



enum WarningPopUpEnum {
  case unsavedHighlight(HighlightActionCode)
  case deleteHighlight

  var title: String {
	 switch self {
	 case .unsavedHighlight:
		"You have some unfinished business"
	 case .deleteHighlight:
		"Delete this highlight?"
	 }
  }

  var caption: String {
	 switch self {
	 case .unsavedHighlight(let code):
		code.warningText
	 case .deleteHighlight:
		"This action can't be undone."
	 }
  }

  var confirmText: String {
	 switch self {
	 case .unsavedHighlight:
		"Leave"
	 case .deleteHighlight:
		"Delete"
	 }
  }
}



enum SmallPopUpEnum {
  case read, save, dismiss, created, edited, deleted, copied, error
  
  var title: String {
	 switch self {
	 case .read:
		"Marked as read!"
	 case .save:
		"Successfully saved!"
	 case .dismiss:
		"Successfully dismissed!"
	 case .created:
		"Highlight created!"
	 case .edited:
		"Highlight edited!"
	 case .deleted:
		"Highlight deleted!"
	 case .copied:
		"Text copied!"
	 case .error:
		"Something went Wrong!"
	 }
  }
}


