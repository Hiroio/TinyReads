//
//  ReadCategories.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import Foundation
import SwiftUI




// MARK: Category Enum
enum ReadCategories: String, CaseIterable, Identifiable{
  case science, history, culture, psychology, philosophy, nature, finance, health, technology
  
  var id: String { self.rawValue}
  
  var title: LocalizedStringKey {
	 switch self {
	 case .science:
		"Science"
	 case .history:
		"History"
	 case .culture:
		"Culture"
	 case .psychology:
		"Psychology"
	 case .philosophy:
		"Philosophy"
	 case .nature:
		"Nature"
	 case .finance:
		"Finance"
	 case .health:
		"Health"
	 case .technology:
		"Technology"
	 }
  }
  
  var limit: Int{
	 switch self {
	 default:
		100
	 }
  }

  /// StoreKit product ID of this category's extra-cards pack, if one exists yet.
  var extraPackStoreID: String? {
	 switch self {
	 case .science: StoreCategoriesConfigurationEnum.sciencePack.storeID
	 case .history: StoreCategoriesConfigurationEnum.historyPack.storeID
	 case .psychology: StoreCategoriesConfigurationEnum.psychologyPack.storeID
	 case .philosophy: StoreCategoriesConfigurationEnum.philosophyPack.storeID
	 case .finance: StoreCategoriesConfigurationEnum.financePack.storeID
	 case .culture, .nature, .health, .technology: nil
	 }
  }

  /// Base limit, extended by 100 if the user owns this category's pack.
  func effectiveLimit(purchasedIDs: Set<String>) -> Int {
	 guard let packID = extraPackStoreID, purchasedIDs.contains(packID) else { return limit }
	 return limit + 100
  }

  func userDefaultKey(language: LanguageEnum) -> String {
	 "\(language.code)_\(self.rawValue)_key"
  }

  /// The Universal-equivalent subCategory for this category — used only to migrate the old,
  /// pre-subcategory `selectedCategories` (category-id) values into the subCategory-id model.
  var migration: any ReadSubCategory {
	 switch self {
	 case .science: ScienceSubCategory.scienceUniversal
	 case .history: HistorySubCategory.historyUniversal
	 case .culture: CultureSubCategory.cultureUniversal
	 case .psychology: PsychologySubCategory.psychologyUniversal
	 case .philosophy: PhilosophySubCategory.philosophyUniversal
	 case .nature: NatureSubCategory.natureUniversal
	 case .finance: FinanceSubCategory.financeUniversal
	 case .health: HealthSubCategory.healthUniversal
	 case .technology: TechnologySubCategory.technologyUniversal
	 }
  }

  /// All subCategories ("books") available on this category's shelf.
  var subCategories: [any ReadSubCategory] {
	 switch self {
	 case .science: ScienceSubCategory.allCases as [ScienceSubCategory]
	 case .history: HistorySubCategory.allCases
	 case .culture: CultureSubCategory.allCases as [CultureSubCategory]
	 case .psychology: PsychologySubCategory.allCases
	 case .philosophy: PhilosophySubCategory.allCases
	 case .nature: NatureSubCategory.allCases
	 case .finance: FinanceSubCategory.allCases
	 case .health: HealthSubCategory.allCases
	 case .technology: TechnologySubCategory.allCases
	 }
  }
}






protocol ReadSubCategory: CaseIterable, Identifiable {
  /// Unique per case within the enum — used only for SwiftUI identity (ForEach etc).
  var id: String { get }
  /// "" for a Universal-equivalent bucket, "_xxx" otherwise — used only to build `coreDataId`.
  /// Two different cases (e.g. Science's .universal and .space) are allowed to share the same suffix.
  var idSuffix: String { get }
  var category: String { get }
  /// Which shelf/cabinet this subCategory is shown under. Normally matches `category`,
  /// but can diverge (e.g. Science's `.space` case has category "space" for Firestore continuity,
  /// yet still belongs on the Science shelf).
  var parentCategory: ReadCategories { get }
  var storeId: String? { get }
  var title: LocalizedStringKey { get }
  var image: String { get }
  var count: Int { get }
}

extension ReadSubCategory {
  /// Stable key for progress-tracking dictionaries ([String: Int]) and Firestore document IDs —
  /// equals `category` alone when `idSuffix` is "", preserving existing users' progress.
  var coreDataId: String { "\(category)\(idSuffix)" }
}

/// Resolves a subCategory by its `coreDataId` — the single mechanism for migrating any legacy,
/// category-only id (old `selectedCategories` entries, old Core Data `categoryId`) into the new
/// subCategory model. Unlike `ReadCategories(rawValue:).migration`, this also correctly resolves
/// "space" — a category-level id that predates the Space→Science merge and no longer matches any
/// `ReadCategories` case — because `ScienceSubCategory.space.coreDataId` is still "space".
func subCategory(forCoreDataId coreDataId: String) -> (any ReadSubCategory)? {
  ReadCategories.allCases.flatMap(\.subCategories).first(where: { $0.coreDataId == coreDataId })
}

