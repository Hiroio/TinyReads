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
}
