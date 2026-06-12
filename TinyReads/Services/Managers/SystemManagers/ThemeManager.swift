//
//  ThemeManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
  case light, dark, system
  
  var icon: String{
	 switch self {
	 case .light:
		"sun.max"
	 case .dark:
		"moon"
	 case .system:
		"iphone.circle"
	 }
  }
  
  var activeIcon: String{
	 switch self {
	 case .light:
		"sun.max.fill"
	 case .dark:
		"moon.fill"
	 case .system:
		"iphone.circle.fill"
	 }
  }
  
  var assets: AppThemeAssets{
	 switch self {
	 case .light:
		  .light
	 case .dark:
		  .dark
	 case .system:
		  .light
	 }
  }
}

@Observable
final class ThemeManager{
  var appTheme: AppTheme{
	 didSet{
		userDefaults.selectedColorTheme = appTheme
	 }
  }
  
  let userDefaults = UserDefaultsManager.shared
  
  init(){
	 self.appTheme = userDefaults.selectedColorTheme
  }
  
  var themeAssets: AppThemeAssets{
	 appTheme.assets
  }
}


enum AppThemeAssets {
  case light, dark
  
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
  
  var navigationExplore: String{
	 switch self {
	 case .light:
		"nav_explore_light"
	 case .dark:
		"nav_explore_dark"
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
}
