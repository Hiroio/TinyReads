//
//  UserDefaultsManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

protocol UserDefaultsManagerProtocol{
  var selectedCategories: [String] { get set }
}

// MARK: MAIN FOR APPLICATION
@Observable
final class UserDefaultsManager: UserDefaultsManagerProtocol {
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
	 let selectedCategory = UserDefaults.standard.array(forKey: selectedCategoriesKey) as? [String] ?? []
	 self.selectedCategories = selectedCategory
	 
	 let colorTheme = UserDefaults.standard.string(forKey: selectedColorThemeKey) ?? ""
	 self.selectedColorTheme = AppTheme(rawValue: colorTheme) ?? .system
  }
  
  func toggleCategory(_ category: ReadCategories) {
	 if selectedCategories.contains(category.rawValue) {
		selectedCategories.removeAll { $0 == category.rawValue }
	 } else {
		selectedCategories.append(category.rawValue)
	 }
  }
}



// MARK: MOCK USERDEFAULT FOR TESTING
final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
	 var selectedCategories: [String] = []
  
  init(selectedCategories: [String] = []){
	 self.selectedCategories = selectedCategories
  }
}
