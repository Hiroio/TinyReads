//
//  ArchiveViewModel.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import Foundation

@MainActor
@Observable
final class ArchiveViewModel{
  var reads: [DisplayReadCard] {
	 archiveManager.cards
  }
  var error: Error? = nil
  /// Shows the category books grid in place of the cards.
  var categoriesFilter: Bool = false
  /// Shows the subCategory filter sheet.
  var subCategoriesFilter: Bool = false
  var selectedCategories: [ReadCategories] = [] {
			 didSet { applyFilters() }
		}
  
  var searchText = "" {
			 didSet { restartSearchDebounce() }
		}
  private var searchTask: Task<Void, Never>? = nil
		
  /// SubCategory ids the archive is filtered by. Empty means "everything".
  var selectedSubCategoryIds: Set<String> = [] {
			 didSet { applyFilters() }
		}
  
  var filteredResults: [DisplayReadCard] = []
  
  private let archiveManager = ArchiveManager.shared
  private let userDefault = UserDefaultsManager.shared
  
  var state: ArchiveState {
	 archiveManager.state
  }
  
  init(){
  }
}

// MARK: Archive functions
extension ArchiveViewModel{
//  Load Manager
  func initialize() async {
	 do{
		try await archiveManager.initializeManager()
	 }catch{
		self.error = error
	 }
	 
	 applyFilters()
  }
  
  
  func onInteractionChange(_ id: String) {
	 archiveManager.applyInteractionChange(id)
	 applyFilters()
  }

  func changeState(_ state: ArchiveState){
	 archiveManager.state = state
	 applyFilters()
  }

func applyFilters() {
  var results = filterableCards

		  if !selectedSubCategoryIds.isEmpty {
			 results = results.filter { item in
				guard let subCategory = item.card.resolvedSubCategory else { return false }
				return selectedSubCategoryIds.contains(subCategory.id)
			 }
		  }
		  
		  if !searchText.isEmpty {
			 results = results.filter { $0.card.title.localizedCaseInsensitiveContains(searchText) }
		  }
		  
		  filteredResults = results
	 }
	 
	 private func restartSearchDebounce() {
		  searchTask?.cancel()
		  
		  searchTask = Task { @MainActor in
				do {
					 try await Task.sleep(for: .milliseconds(400))
					 applyFilters()
				} catch { }
		  }
	 }
  
}


// MARK: Category filter
extension ArchiveViewModel{
  func selectCategory(category: ReadCategories){
	 if selectedCategories.contains(where: {$0.rawValue == category.rawValue}){
		selectedCategories.removeAll(where: {$0.rawValue == category.rawValue})
	 }else{
		selectedCategories.append(category)
	 }
  }

  /// Which shelf a card belongs to. Goes through the subCategory rather than `card.categoryId`,
  /// so Space cards (categoryId "space") still land under Science.
  private func parentCategory(of card: ReadCardModel) -> ReadCategories? {
	 card.resolvedSubCategory?.parentCategory
  }
}


// MARK: SubCategory filter
extension ArchiveViewModel{
  /// Everything the current tab + language + selected categories could show, before the
  /// subCategory filter narrows it further. The offered books and their counts both come from
  /// here, so an option can never lead nowhere — and the sheet only lists books from the
  /// categories that are actually selected.
  private var filterableCards: [DisplayReadCard] {
	 var results = archiveManager.visibleCards.filter { $0.card.languageCode == userDefault.selectedLanguage.code }

	 if !selectedCategories.isEmpty {
		results = results.filter { item in
		  guard let parent = parentCategory(of: item.card) else { return false }
		  return selectedCategories.contains(parent)
		}
	 }

	 return results
  }

  /// Books the user actually has cards from, minus the ones already picked.
  var availableSubCategories: [any ReadSubCategory] {
	 let ids = Set(filterableCards.compactMap { $0.card.resolvedSubCategory?.id })
	 return ReadCategories.allCases
		.flatMap(\.subCategories)
		.filter { ids.contains($0.id) && !selectedSubCategoryIds.contains($0.id) }
  }

  /// Resolved from the ids rather than from the archive — so a pick stays visible (and clearable)
  /// even after switching to a tab where it has no cards.
  var selectedSubCategories: [any ReadSubCategory] {
	 ReadCategories.allCases
		.flatMap(\.subCategories)
		.filter { selectedSubCategoryIds.contains($0.id) }
  }

  func cardsCount(for subCategory: any ReadSubCategory) -> Int {
	 filterableCards.filter { $0.card.resolvedSubCategory?.id == subCategory.id }.count
  }

  func toggleSubCategory(_ subCategory: any ReadSubCategory) {
	 if selectedSubCategoryIds.contains(subCategory.id) {
		selectedSubCategoryIds.remove(subCategory.id)
	 } else {
		selectedSubCategoryIds.insert(subCategory.id)
	 }
  }

  func clearSubCategoryFilter() {
	 selectedSubCategoryIds.removeAll()
  }
}
