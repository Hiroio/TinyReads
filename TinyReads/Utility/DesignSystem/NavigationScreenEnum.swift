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



enum SmallPopUpEnum {
  case read, save, dismiss, created, edited, copied, error
  
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
	 case .copied:
		"Text copied!"
	 case .error:
		"Something went Wrong!"
	 }
  }
}


