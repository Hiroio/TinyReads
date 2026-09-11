//
//  UserDefaultsManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

protocol UserDefaultsManagerProtocol{
  var selectedCategories: [String] { get set }
  /// SubCategory ids (`ReadSubCategory.id`) selected by the user — supersedes `selectedCategories`.
  var selectedSubCategories: [String] { get set }
  var selectedLanguage: LanguageEnum { get set }
}

// MARK: MAIN FOR APPLICATION
@Observable
final class UserDefaultsManager: UserDefaultsManagerProtocol {
  static let shared = UserDefaultsManager()
  
  private let selectedCategoriesKey = "selectedCategories"
  private let selectedSubCategoriesKey = "selectedSubCategories"
  private let selectedColorThemeKey = "selectedColorTheme"
  private let selectedLanguageKey = "selectedLanguage"
  private let onBoardingKey = "onBoardingCompletion"
  private let avaratKey = "SelectedIndexAvatar"

  /// Shared with the widget extension so it can read the app's current language.
  private let sharedDefaults = UserDefaults(suiteName: "group.com.hiroio.tinyreads") ?? .standard
  var selectedCategories: [String] {
	 didSet {
		UserDefaults.standard.set(selectedCategories, forKey: selectedCategoriesKey)
	 }
  }

  var selectedSubCategories: [String] {
	 didSet {
		UserDefaults.standard.set(selectedSubCategories, forKey: selectedSubCategoriesKey)
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
		sharedDefaults.set(selectedLanguage.rawValue, forKey: selectedLanguageKey)
	 }
  }
  
  var selectedAvatarIndex: Int {
	 didSet{
		UserDefaults.standard.set(selectedAvatarIndex, forKey: avaratKey)
	 }
  }
  
  
  
  private init() {
	 let selectedCategory = UserDefaults.standard.array(forKey: selectedCategoriesKey) as? [String] ?? []

	 if let storedSubCategories = UserDefaults.standard.array(forKey: selectedSubCategoriesKey) as? [String] {
		self.selectedCategories = selectedCategory
		self.selectedSubCategories = storedSubCategories
	 } else {
		//  migrate the old, category-level selection into the new subCategory-id model —
		//  each legacy category id becomes the subCategory whose coreDataId matches it
		//  (that category's Universal, or "space" itself for the pre-merge Space category).
		let migratedSubCategories = selectedCategory.compactMap { subCategory(forCoreDataId: $0)?.id }
		self.selectedSubCategories = migratedSubCategories
		UserDefaults.standard.set(migratedSubCategories, forKey: selectedSubCategoriesKey)

		//  legacy key has served its purpose — drop it so nothing reads a stale,
		//  category-level selection again. (didSet does not fire inside init, so the
		//  stored value is removed explicitly.)
		self.selectedCategories = []
		UserDefaults.standard.removeObject(forKey: selectedCategoriesKey)
	 }

	 let colorTheme = UserDefaults.standard.string(forKey: selectedColorThemeKey) ?? ""
	 self.selectedColorTheme = AppTheme(rawValue: colorTheme) ?? .system
	 
	 let onBoardingCompletion = UserDefaults.standard.bool(forKey: onBoardingKey)
	 self.onBoardingCompletion = onBoardingCompletion
	 
	 if let sharedLanguage = sharedDefaults.string(forKey: selectedLanguageKey) {
		self.selectedLanguage = LanguageEnum(rawValue: sharedLanguage) ?? .en
	 } else {
		//  migrate a pre-existing language choice from the old, app-only UserDefaults
		let legacyLanguage = UserDefaults.standard.string(forKey: selectedLanguageKey) ?? ""
		let migratedLanguage = LanguageEnum(rawValue: legacyLanguage) ?? .en
		self.selectedLanguage = migratedLanguage
		sharedDefaults.set(migratedLanguage.rawValue, forKey: selectedLanguageKey)
	 }
	 
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
  func getCategoryReadedCount(for subCategory: any ReadSubCategory, language: LanguageEnum? = nil) -> Int{
	 let language = language ?? selectedLanguage
	 return UserDefaults.standard.integer(forKey: subCategory.userDefaultKey(language: language))
  }
  /// setting number
  func setCategoryReadedCount(for subCategoryId: String, index: Int, language: LanguageEnum? = nil){
	 guard let subCategory = TinyReads.subCategory(forId: subCategoryId) else { return }
	 let language = language ?? selectedLanguage
	 guard getCategoryReadedCount(for: subCategory, language: language) < index else { return }

	 UserDefaults.standard.set(index, forKey: subCategory.userDefaultKey(language: language))
  }
}


// MARK: MOCK USERDEFAULT FOR TESTING
final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
	 var selectedCategories: [String] = []
  var selectedSubCategories: [String] = []
  var selectedLanguage: LanguageEnum = .en

  init(selectedCategories: [String] = [], selectedSubCategories: [String] = [], selectedLanguage: LanguageEnum = .en){
	 self.selectedCategories = selectedCategories
	 self.selectedSubCategories = selectedSubCategories
	 self.selectedLanguage = selectedLanguage
  }
}
