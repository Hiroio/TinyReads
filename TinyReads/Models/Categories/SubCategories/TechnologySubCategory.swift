//
//  TechnologySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum TechnologySubCategory: String, ReadSubCategory {
  case technologyUniversal, artificialIntelligence, internet

  var id: String { rawValue }

  var idSuffix: String {
	 self == .technologyUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.technology.rawValue }

  var parentCategory: ReadCategories { .technology }

  var storeId: String? {
	 switch self {
	 case .technologyUniversal: nil
	 case .artificialIntelligence: "com.hiroio.tinyreads.subcategory.technology.artificialIntelligence"
	 case .internet: "com.hiroio.tinyreads.subcategory.technology.internet"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .technologyUniversal: "Universal"
	 case .artificialIntelligence: "AI"
	 case .internet: "Internet"
	 }
  }

  var image: String {
	 switch self {
	 case .technologyUniversal: "Technology"
	 case .artificialIntelligence: "AI"
	 case .internet: "Internet"
	 }
  }

  var count: Int {
	 switch self {
	 case .technologyUniversal: 100
	 case .artificialIntelligence: 80
	 default: 80
	 }
  }
}
