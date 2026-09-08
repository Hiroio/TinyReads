//
//  NatureSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum NatureSubCategory: String, ReadSubCategory {
  case natureUniversal, ocean

  var id: String { rawValue }

  var idSuffix: String {
	 self == .natureUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.nature.rawValue }

  var parentCategory: ReadCategories { .nature }

  var storeId: String? {
	 switch self {
	 case .natureUniversal: nil
	 case .ocean: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .natureUniversal: "Universal"
	 case .ocean: "Ocean"
	 }
  }

  var image: String {
	 switch self {
	 case .natureUniversal: "Nature"
	 case .ocean: "Nature"
	 }
  }

  var count: Int {
	 switch self {
	 case .natureUniversal: 100
	 case .ocean: 80
	 }
  }
}
