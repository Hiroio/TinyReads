//
//  ThemeManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation
import SwiftUI

@Observable
final class ThemeManager{
  var colorSceme: ColorScheme = .light
  
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
	 switch appTheme {
	 case .light:
		  .light
	 case .dark:
		  .dark
	 case .system:
		colorSceme == .dark ? .dark : .light
	 }
  }
}



