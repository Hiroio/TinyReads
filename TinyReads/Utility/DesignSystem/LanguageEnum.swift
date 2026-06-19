//
//  LanguageEnum.swift
//  TinyReads
//
//  Created by user on 17.06.2026.
//

import Foundation
import SwiftUI


enum LanguageEnum: String, Identifiable, CaseIterable{
  case en 
  case uk
  
  var id: String { self.rawValue }
  
  var code: String {
	 rawValue
  }
  
  var title: LocalizedStringKey {
	 switch self {
	 case .en:
		"English"
	 case .uk:
		"Ukrainian"
	 }
  }
}
