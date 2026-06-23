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
  var colorScheme: ColorScheme = .light
  
  var appTheme: AppTheme{
	 didSet{
		userDefaults.selectedColorTheme = appTheme
	 }
  }
  
  var themeAssets: AppThemeAssets
  
  let userDefaults = UserDefaultsManager.shared
  
  init(){
	 let selectedColorTheme = userDefaults.selectedColorTheme
	 self.appTheme = selectedColorTheme
	 self.themeAssets = selectedColorTheme.assets
  }
  
  
  func changeColorTheme() {
	 var assets = appTheme.assets
	 switch appTheme {
	 case .light:
		assets = .light
	 case .dark:
		assets = .dark
	 case .system:
		assets = colorScheme == .dark ? .dark : .light
	 }
	 
	 self.themeAssets = assets
	 print(themeAssets)
  }
  
}



