//
//  AppThemeEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation

enum AppTheme: String, CaseIterable {
  case light, dark, system
  
  var icon: String {
	 switch self {
	 case .light:
		"sun.max"
	 case .dark:
		"moon"
	 case .system:
		"iphone.circle"
	 }
  }
  
  var activeIcon: String {
	 switch self {
	 case .light:
		"sun.max.fill"
	 case .dark:
		"moon.fill"
	 case .system:
		"iphone.circle.fill"
	 }
  }
  
  var assets: AppThemeAssets {
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
