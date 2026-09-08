//
//  TechnologySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum TechnologySubCategory: String, ReadSubCategory {
  case technologyUniversal, artificial

  var id: String { rawValue }

  var idSuffix: String {
	 self == .technologyUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.technology.rawValue }

  var parentCategory: ReadCategories { .technology }

  var storeId: String? {
	 switch self {
	 case .technologyUniversal: nil
	 case .artificial: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .technologyUniversal: "Universal"
	 case .artificial: "AI"
	 }
  }

  var image: String {
	 switch self {
	 case .technologyUniversal: "Technology"
	 case .artificial: "Technology"
	 }
  }

  var count: Int {
	 switch self {
	 case .technologyUniversal: 100
	 case .artificial: 80
	 }
  }
}
