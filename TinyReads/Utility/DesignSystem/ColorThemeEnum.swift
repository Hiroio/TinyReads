//
//  ColorThemeEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation
import SwiftUI


enum AppThemeAssets: String, Identifiable {
  case light, dark
  
  var id: String{ self.rawValue.capitalized}
  
//  MARK: - Colors
  var background: Color{
	 switch self {
	 case .light:
		Color.backgroundLight
	 case .dark:
		Color.backgroundD
	 }
  }
  
  
  var card: Color {
	 switch self {
	 case .light:
		  Color.cardLight
	 case .dark:
		  Color.cardD
	 }
  }
  
  var primary: Color{
	 switch self {
	 case .light:
		  .primaryLight
	 case .dark:
		  .primaryD
	 }
  }
  
  var accent: Color{
	 switch self {
	 case .light:
		  .accentLight
	 case .dark:
		  .accentD
	 }
  }
  
  var border: Color{
	 switch self {
	 case .light:
		  Color.border
	 case .dark:
		  Color.borderD
	 }
  }
  
  var secondary: Color{
	 switch self {
	 case .light:
		  Color.secondaryLight
	 case .dark:
		Color.secondaryD
	 }
  }
  
  
  
//  MARK: - BackGround Cards
  var backCard: String{
	 switch self {
	 case .light:
		"backcard_light_tight"
	 case .dark:
		"backcard_black_tight"
	 }
  }
  
  var savedCard: String{
	 switch self {
	 case .light:
		"SavedCard"
	 case .dark:
		"SavedCardDark"
	 }
  }
  var dismissedCard: String{
	 switch self {
	 case .light:
		"DismissedBack"
	 case .dark:
		"DismissedBackDark"
	 }
  }
  
  var readerCard: String{
	 switch self {
	 case .light:
		"ReaderCard"
	 case .dark:
		"ReaderCardDark"
	 }
  }
  
  var backSmallCard: String{
	 switch self {
	 case .light:
		"backGroundCard"
	 case .dark:
		"backGroundCardDark"
	 }
  }
  
  var topArticleCard: String{
	 switch self {
	 case .light:
		"topArticleCardLight"
	 case .dark:
		"topArticleCardDark"
	 }
  }
  
  var middleArticleCard: String{
	 switch self {
	 case .light:
		"middleArticleCardLight"
	 case .dark:
		"middleArticleCardDark"
	 }
  }
  
  var bottomArticleCard: String{
	 switch self {
	 case .light:
		"bottomArticleCardLight"
	 case .dark:
		"bottomArticleCardDark"
	 }
  }
  
  
//  MARK: - Actions Icons
  var saveAction: String{
	 switch self {
	 case .light:
		"SaveActionLight"
	 case .dark:
		"SaveActionDark"
	 }
  }
  
//  - Profile Actions
  var languageAction: String{
	 switch self {
	 case .light:
		"LanguageActionIcon"
	 case .dark:
		"LanguageActionIconDark"
	 }
  }
  
  var categorieAction: String{
	 switch self {
	 case .light:
		"ThemeActionIcon"
	 case .dark:
		"ThemeActionIconDark"
	 }
  }
  
  var themeAction: String{
	 switch self {
	 case .light:
		"ThemeActionIcon"
	 case .dark:
		"ThemeActionIconDark"
	 }
  }
  
  var freshSwipeMode: String{
	 switch self {
	 case .light:
		"FreshModeSwipeLight"
	 case .dark:
		"FreshModeSwipeDark"
	 }
  }
  
  var repeatSwipeMode: String{
	 switch self {
	 case .light:
		"RepeatModeSwipeLight"
	 case .dark:
		"RepeatModeSwipeDark"
	 }
  }
  
//  - Main Navigation
  var navigationProfile: String{
	 switch self {
	 case .light:
		"nav_profile_light"
	 case .dark:
		"nav_profile_dark"
	 }
  }
  
  var navigationSkipped: String{
	 switch self {
	 case .light:
		"nav_skipped_light"
	 case .dark:
		"nav_skipped_dark"
	 }
  }
  
  var navigationArchive: String{
	 switch self {
	 case .light:
		"nav_archive_light"
	 case .dark:
		"nav_archive_dark"
	 }
  }
  
  var navigationStore: String{
	 switch self {
	 case .light:
		"nav_store_light"
	 case .dark:
		"nav_store_dark"
	 }
  }
  
  var navigationCategories: String{
	 switch self {
	 case .light:
		"nav_categories_light"
	 case .dark:
		"nav_categories_dark"
	 }
  }
  
  
//  MARK: OTHERS
  var emptyState: String{
	 switch self {
	 case .light:
		"EmptyState"
	 case .dark:
		"EmptyStateDark"
	 }
  }
}
