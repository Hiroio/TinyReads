//
//  HealthSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HealthSubCategory: String, ReadSubCategory {
  case healthUniversal, sleep

  var id: String { rawValue }

  var idSuffix: String {
	 self == .healthUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.health.rawValue }

  var parentCategory: ReadCategories { .health }

  var storeId: String? {
	 switch self {
	 case .healthUniversal: nil
	 case .sleep: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .healthUniversal: "Universal"
	 case .sleep: "Sleep"
	 }
  }

  var image: String {
	 switch self {
	 case .healthUniversal: "Health"
	 case .sleep: "Health"
	 }
  }

  var count: Int {
	 switch self {
	 case .healthUniversal: 100
	 case .sleep: 80
	 }
  }
}
