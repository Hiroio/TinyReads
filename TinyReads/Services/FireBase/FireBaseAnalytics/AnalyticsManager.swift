//
//  AnalyticsManager.swift
//  TinyReads
//
//  Created by user on 27.06.2026.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
	 static let shared = AnalyticsManager()

	 private init() {}

	 func categoryCompleted(categoryId: String, language: String) {
		  Analytics.logEvent("category_completed", parameters: [
				"category_id": categoryId,
				"language": language
		  ])
	 }
  
  func readCard(card: ReadCardModel){
	 Analytics.logEvent("card_read", parameters: [
		"card_name": card.title,
		"card_category": card.categoryId,
		"card_language": card.languageCode
	 ])
  }
}
