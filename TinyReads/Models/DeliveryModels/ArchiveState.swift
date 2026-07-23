//
//  ArchiveState.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation
import SwiftUI

enum ArchiveState: String, CaseIterable, Identifiable {
  case all, dismissed, saved, read
  
  var id: String {
	 self.rawValue
  }
  
  var text: LocalizedStringKey {
	 switch self {
	 case .all:
		"All"
	 case .dismissed:
		"Dismissed"
	 case .saved:
		"Saved"
	 case .read:
		"Read"
	 }
  }
  
  var cardStatus: ReadCardDisplayStatus? {
	 switch self {
	 case .all:
		  nil
	 case .dismissed:
		  .dismissed
	 case .saved:
		  .archived
	 case .read:
		  .read
	 }
  }
}
