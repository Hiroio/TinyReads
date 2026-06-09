//
//  ArchiveState.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation

enum ArchiveState: String, CaseIterable, Identifiable {
  case saved, read
  
  var id: String {
	 self.rawValue
  }
  
  var text: String {
	 self.rawValue.capitalized
  }
}
