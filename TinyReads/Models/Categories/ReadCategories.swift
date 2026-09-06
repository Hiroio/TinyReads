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
  case science, history, culture, psychology, philosophy, nature, finance, health, space, technology
  
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
	 case .space:
		"Space"
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
	 case .culture, .nature, .health, .space, .technology: nil
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
	 case .space: SpaceSubCategory.allCases
	 case .technology: TechnologySubCategory.allCases
	 }
  }
}






protocol ReadSubCategory: CaseIterable, Identifiable {
  var id: String { get }
  var category: String { get }
  var storeId: String? { get }
  var title: LocalizedStringKey { get }
  var image: String { get }
  var count: Int { get }
}

extension ReadSubCategory {
  /// Stable key for progress-tracking dictionaries ([String: Int]) and Firestore document IDs —
  /// equals `category` alone for Universal (since `id` is "" there), preserving existing users' progress.
  var coreDataId: String { "\(category)\(id)" }
}
