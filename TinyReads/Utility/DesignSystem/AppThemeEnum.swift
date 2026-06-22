//
//  AppThemeEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation
import UIKit

enum AppTheme: String, CaseIterable, Equatable {
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
		return .light
	 case .dark:
		return .dark
	 case .system:
		return .light
	 }
  }
}





