//
//  DisplayReadCard.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation

struct DisplayReadCard: Identifiable, Equatable {
	 let card: ReadCardModel
	 let status: ReadCardDisplayStatus

	 var id: String { card.id }
}



enum ReadCardDisplayStatus: Equatable {
	 case fresh
	 case dismissed
	 case read
	 case archived
  
  var title: String {
	 switch self {
	 case .fresh:
		"Fresh"
	 case .dismissed:
		"Dismissed"
	 case .read:
		"Read"
	 case .archived:
		"Archived"
	 }
  }
  
  var backCard: String{
	 switch self{
	 case .dismissed:
		"DismissedBack"
	 default:
		"SavedBack"
	 }
  }
}
