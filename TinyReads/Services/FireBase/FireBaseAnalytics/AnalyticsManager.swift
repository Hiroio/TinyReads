//
//  AnalyticsManager.swift
//  TinyReads
//
//  Created by user on 27.06.2026.
//

import Foundation
import FirebaseAnalytics
import StoreKit

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


// MARK: - Purchases
extension AnalyticsManager {
  /// Tapped a book they do not own yet — intent, logged before StoreKit gets involved.
  func bookLockedTapped(_ subCategory: any ReadSubCategory) {
	 Analytics.logEvent("book_locked_tapped", parameters: [
		"sub_category_id": subCategory.id,
		"category_id": subCategory.parentCategory.rawValue
	 ])
  }

  func purchaseStarted(productId: String) {
	 Analytics.logEvent("purchase_started", parameters: ["product_id": productId])
  }

  /// Logs both the funnel step and the standard `purchase` event — StoreKit 2 purchases are not
  /// collected automatically, so without this Firebase reports zero revenue.
  func purchaseCompleted(product: Product, transactionId: UInt64) {
	 Analytics.logEvent(AnalyticsEventPurchase, parameters: [
		AnalyticsParameterValue: NSDecimalNumber(decimal: product.price).doubleValue,
		AnalyticsParameterCurrency: product.priceFormatStyle.currencyCode,
		AnalyticsParameterTransactionID: String(transactionId),
		AnalyticsParameterItemID: product.id
	 ])

	 Analytics.logEvent("purchase_completed", parameters: ["product_id": product.id])
  }

  func purchaseCancelled(productId: String) {
	 Analytics.logEvent("purchase_cancelled", parameters: ["product_id": productId])
  }

  func purchaseFailed(productId: String, reason: String) {
	 Analytics.logEvent("purchase_failed", parameters: [
		"product_id": productId,
		"reason": reason
	 ])
  }

  func restoreTapped(source: String) {
	 Analytics.logEvent("restore_tapped", parameters: ["source": source])
  }

  func restoreCompleted(source: String, restoredCount: Int) {
	 Analytics.logEvent("restore_completed", parameters: [
		"source": source,
		"restored_count": restoredCount
	 ])
  }
}


// MARK: - Book selection
extension AnalyticsManager {
  /// `source` — where the book was picked: "shelf" or "onboarding".
  func bookSelectionChanged(_ subCategory: any ReadSubCategory, selected: Bool, source: String) {
	 Analytics.logEvent(selected ? "book_selected" : "book_deselected", parameters: [
		"sub_category_id": subCategory.id,
		"category_id": subCategory.parentCategory.rawValue,
		"is_free": subCategory.storeId == nil,
		"source": source
	 ])
  }
}


// MARK: - Onboarding
extension AnalyticsManager {
  func onboardingStep(_ step: String) {
	 Analytics.logEvent("onboarding_step", parameters: ["step": step])
  }

  func onboardingCompleted(booksCount: Int) {
	 Analytics.logEvent("onboarding_completed", parameters: ["books_count": booksCount])
  }
}
