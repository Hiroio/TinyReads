//
//  LanguageEnum.swift
//  TinyReads
//
//  Created by user on 17.06.2026.
//

import Foundation


enum LanguageEnum: String, Identifiable, CaseIterable{
  case en = "English"
  case uk = "Ukrainian"
  
  var id: String { self.rawValue }
}
