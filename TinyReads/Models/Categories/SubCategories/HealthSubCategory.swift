//
//  HealthSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HealthSubCategory: String, ReadSubCategory {
  case healthUniversal, sleep, immuneSystem

  var id: String { rawValue }

  var idSuffix: String {
	 self == .healthUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.health.rawValue }

  var parentCategory: ReadCategories { .health }

  var storeId: String? {
	 switch self {
	 case .healthUniversal: nil
	 case .sleep: "com.hiroio.tinyreads.subcategory.health.sleep"
	 case .immuneSystem: "com.hiroio.tinyreads.subcategory.health.immuneSystem"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .healthUniversal: "Universal"
	 case .sleep: "Sleep"
	 case .immuneSystem: "Immune System"
	 }
  }

  var image: String {
	 switch self {
	 case .healthUniversal: "Health"
	 case .sleep: "Sleep"
	 case .immuneSystem: "ImmuneSystem"
	 }
  }

  var count: Int {
	 switch self {
	 case .healthUniversal: 100
	 case .sleep: 80
	 default: 80
	 }
  }
}
