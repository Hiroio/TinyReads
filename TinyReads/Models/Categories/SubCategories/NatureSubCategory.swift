//
//  NatureSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum NatureSubCategory: String, ReadSubCategory {
  case natureUniversal, oceanMarineLife, arcticAntarctic

  var id: String { rawValue }

  var idSuffix: String {
	 self == .natureUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.nature.rawValue }

  var parentCategory: ReadCategories { .nature }

  var storeId: String? {
	 switch self {
	 case .natureUniversal: nil
	 case .oceanMarineLife: "com.hiroio.tinyreads.subcategory.nature.oceanMarineLife"
	 case .arcticAntarctic: "com.hiroio.tinyreads.subcategory.nature.arcticAntarctic"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .natureUniversal: "Universal"
	 case .oceanMarineLife: "Ocean"
	 case .arcticAntarctic: "Arctic"
	 }
  }

  var image: String {
	 switch self {
	 case .natureUniversal: "Nature"
	 case .oceanMarineLife: "Ocean"
	 case .arcticAntarctic: "Arctic"
	 }
  }

  var count: Int {
	 switch self {
	 case .natureUniversal: 100
	 case .oceanMarineLife: 80
	 default: 80
	 }
  }
}
