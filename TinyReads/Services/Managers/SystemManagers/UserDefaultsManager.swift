//
//  UserDefaultsManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

protocol UserDefaultsManagerProtocol{
  var selectedCategories: [String] { get set }
  var selectedLanguage: LanguageEnum { get set }
}

// MARK: MAIN FOR APPLICATION
@Observable
final class UserDefaultsManager: UserDefaultsManagerProtocol {
  static let shared = UserDefaultsManager()
  
  private let selectedCategoriesKey = "selectedCategories"
  private let selectedColorThemeKey = "selectedColorTheme"
  private let selectedLanguageKey = "selectedLanguage"
  private let onBoardingKey = "onBoardingCompletion"
  private let avaratKey = "SelectedIndexAvatar"
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
  
  var onBoardingCompletion: Bool{
	 didSet{
		UserDefaults.standard.set(onBoardingCompletion, forKey: onBoardingKey)
	 }
  }
  
  var selectedLanguage: LanguageEnum{
	 didSet{
		UserDefaults.standard.set(selectedLanguage.rawValue, forKey: selectedLanguageKey)
	 }
  }
  
  var selectedAvatarIndex: Int {
	 didSet{
		UserDefaults.standard.set(selectedAvatarIndex, forKey: avaratKey)
	 }
  }
  
  
  
  private init() {
	 let selectedCategory = UserDefaults.standard.array(forKey: selectedCategoriesKey) as? [String] ?? []
	 self.selectedCategories = selectedCategory
	 
	 let colorTheme = UserDefaults.standard.string(forKey: selectedColorThemeKey) ?? ""
	 self.selectedColorTheme = AppTheme(rawValue: colorTheme) ?? .system
	 
	 let onBoardingCompletion = UserDefaults.standard.bool(forKey: onBoardingKey)
	 self.onBoardingCompletion = onBoardingCompletion
	 
	 let selectedLanguage = UserDefaults.standard.string(forKey: selectedLanguageKey) ?? ""
	 let language = LanguageEnum(rawValue: selectedLanguage) ?? .en
	 self.selectedLanguage = language
	 
	 let avatarIndex = UserDefaults.standard.integer(forKey: avaratKey)
	 self.selectedAvatarIndex = avatarIndex
  }
  
}


extension UserDefaultsManager{
//  MARK: Toggling Category
  func toggleCategory(_ category: ReadCategories) {
	 if selectedCategories.contains(category.rawValue) {
		selectedCategories.removeAll { $0 == category.rawValue }
	 } else {
		selectedCategories.append(category.rawValue)
	 }
  }
  
  
//  MARK: For Category Numbers
  /// getting number
  func getCategoryReadedCount(for category: ReadCategories, language: LanguageEnum? = nil) -> Int{
	 let language = language ?? selectedLanguage
	 return UserDefaults.standard.integer(forKey: category.userDefaultKey(language: language))
  }
  /// setting number
  func setCategoryReadedCount(for category: String, index: Int, language: LanguageEnum? = nil){
	 guard let category = ReadCategories(rawValue: category) else { return }
	 let language = language ?? selectedLanguage
	 guard getCategoryReadedCount(for: category, language: language) < index else { return }
	 
	 UserDefaults.standard.set(index, forKey: category.userDefaultKey(language: language))
  }
}


// MARK: MOCK USERDEFAULT FOR TESTING
final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
	 var selectedCategories: [String] = []
  var selectedLanguage: LanguageEnum = .en
  
  init(selectedCategories: [String] = [], selectedLanguage: LanguageEnum = .en){
	 self.selectedCategories = selectedCategories
	 self.selectedLanguage = selectedLanguage
  }
}
