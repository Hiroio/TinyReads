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


extension DisplayReadCard{
  static var onBoardingCard: [DisplayReadCard] {
	 let firstCard: ReadCardModel = ReadCardModel(id: "onboarding_save", translationGroupId: "", categoryId: "practice", languageCode: "", title: "Swipe right to save", hook: "Keep a tiny idea for later.\nYour archive becomes a quiet shelf of thoughts.", body: "", wordCount: 180, estimatedMinutes: 1, tags: [], sortIndex: 1, isActive: true)
	 
	 let secondCard: ReadCardModel = ReadCardModel(id: "onboarding_skip", translationGroupId: "", categoryId: "practice", languageCode: "", title: "Swipe left to skip", hook: "Not every idea needs your time.\nMove past it and the next one appears.", body: "", wordCount: 150, estimatedMinutes: 1, tags: [], sortIndex: 2, isActive: true)
	
	 return [DisplayReadCard(card: firstCard, status: .fresh), DisplayReadCard(card: secondCard, status: .fresh)]
  }
}
