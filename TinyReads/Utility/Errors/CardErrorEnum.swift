//
//  CardErrorEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation
import SwiftUI

enum CardError: Error, LocalizedError {
  case badInternetConnection
  case somethingWentWrong
  case cardNoLeft
  case noCategories
  
  var title: LocalizedStringKey {
	 switch self {
	 case .badInternetConnection:
		"Bad internet connection"
	 case .somethingWentWrong:
		"Something went wrong"
	 case .cardNoLeft:
		"No cards left"
	 case .noCategories:
		"Select categories"
	 }
  }
  
  var subtitle: LocalizedStringKey {
	 switch self {
	 case .badInternetConnection:
		"Check your connection and try again."
	 case .somethingWentWrong:
		"We could not prepare your reads right now."
	 case .cardNoLeft:
		"You reached the end of this shelf for now."
	 case .noCategories:
		"Choose a few shelves to prepare your reading deck."
	 }
  }
  
  var imageName: String {
	 switch self {
	 case .badInternetConnection:
		"BadInternetConnection"
	 case .somethingWentWrong:
		"SomethingWentWrong"
	 case .cardNoLeft:
		"CardNoLeft"
	 case .noCategories:
		"NoCategories"
	 }
  }
  
  var primaryButtonTitle: LocalizedStringKey {
	 switch self {
	 case .badInternetConnection, .somethingWentWrong:
		"Try again"
	 case .cardNoLeft:
		"Reshuffle viewed"
	 case .noCategories:
		"Select Categories"
	 }
  }
  
  var secondaryButtonTitle: LocalizedStringKey? {
	 switch self {
	 case .cardNoLeft:
		"Change Categories"
	 case .badInternetConnection, .somethingWentWrong:
		"Check Viewed Cards"
	 default:
		nil
	 }
  }
}
