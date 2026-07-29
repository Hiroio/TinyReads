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
  
  func tapToRead(card: ReadCardModel){
	 Analytics.logEvent("card_tapped", parameters: [
		"card_name": card.title,
		"card_category": card.categoryId,
		"card_language": card.languageCode
	 ])
  }
  
  func saveCard(card: ReadCardModel){
	 Analytics.logEvent("card_saved", parameters: [
		"card_name": card.title,
		"card_category": card.categoryId,
		"card_language": card.languageCode
	 ])
  }
  
  func dismissCard(card: ReadCardModel){
	 Analytics.logEvent("card_dismissed", parameters: [
		"card_name": card.title,
		"card_category": card.categoryId,
		"card_language": card.languageCode
	 ])
  }
  
  func highlightCreated(article: String){
	 Analytics.logEvent("highlightCreate", parameters: [
		"card_name": article
	 ])
  }
}
