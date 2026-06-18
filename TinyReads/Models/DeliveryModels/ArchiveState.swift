//
//  ArchiveState.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation
import SwiftUI

enum ArchiveState: String, CaseIterable, Identifiable {
  case saved, read
  
  var id: String {
	 self.rawValue
  }
  
  var text: LocalizedStringKey {
	 switch self {
	 case .saved:
		"Saved"
	 case .read:
		"Read"
	 }
  }
  
  var cardStatus: ReadCardDisplayStatus {
	 switch self {
	 case .saved:
		  .archived
	 case .read:
		  .read
	 }
  }
}
