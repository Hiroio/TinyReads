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
  
  
  func getSubCategory(_ id: String?) -> (any ReadSubCategory)?{
	 return self.subCategories.first(where: { $0.id == id })
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
  var id: String { get }
  var idSuffix: String { get }
  var category: String { get }
  var parentCategory: ReadCategories { get }
  var storeId: String? { get }
  var title: LocalizedStringKey { get }
  var image: String { get }
  var count: Int { get }
}

extension ReadSubCategory {
  var coreDataId: String { "\(category)\(idSuffix)" }

  func userDefaultKey(language: LanguageEnum) -> String {
	 "\(language.code)_\(coreDataId)_key"
  }
}

func subCategory(forCoreDataId coreDataId: String) -> (any ReadSubCategory)? {
  guard coreDataId != "space" else { return ScienceSubCategory.space}
  return ReadCategories.allCases.flatMap(\.subCategories).first(where: { $0.coreDataId == coreDataId })
}


func subCategory(forId id: String) -> (any ReadSubCategory)? {
  guard id != "space" else { return ScienceSubCategory.space}
  return ReadCategories.allCases.flatMap(\.subCategories).first(where: { $0.id == id })
}

