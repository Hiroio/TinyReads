//
//  CardSliderStateEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation

enum DeckMode {
  case freshOnly
  case repeatOld
  
  var image: String {
	 switch self {
	 case .freshOnly:
		"newspaper"
	 case .repeatOld:
		"xmark.bin"
	 }
  }
}
