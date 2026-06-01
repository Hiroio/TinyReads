//
//  UserDefaultsManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

@Observable
final class UserDefaultsManager {
	 static let shared = UserDefaultsManager()

	 private let selectedCategoriesKey = "selectedCategories"
  private let selectedColorThemeKey = "selectedColorTheme"

	 var selectedCategories: [String] {
		  didSet {
				UserDefaults.standard.set(selectedCategories, forKey: selectedCategoriesKey)
		  }
	 }
  
	 var selectedColorTheme: AppTheme {
		  didSet {
			 UserDefaults.standard.set(selectedColorTheme.rawValue, forKey: selectedColorThemeKey)
		  }
	 }
  
  

	 private init() {
		  self.selectedCategories = UserDefaults.standard.array(
				forKey: selectedCategoriesKey
		  ) as? [String] ?? []
		
		self.selectedColorTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: selectedColorThemeKey) ?? "") ?? .system
	 }

	 func toggleCategory(_ category: ReadCategories) {
		  if selectedCategories.contains(category.rawValue) {
				selectedCategories.removeAll { $0 == category.rawValue }
		  } else {
				selectedCategories.append(category.rawValue)
		  }
	 }
}
