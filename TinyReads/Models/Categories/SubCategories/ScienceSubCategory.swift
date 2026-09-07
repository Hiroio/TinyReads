//
//  ScienceSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum ScienceSubCategory: String, ReadSubCategory {
  case universal, physics, space

  var id: String { rawValue }

  //  Space keeps the "" suffix (like Universal) so its already-planned free content
  //  keeps the old standalone-category Firestore id format (space_en_...), unchanged by this merge.
  var idSuffix: String {
	 switch self {
	 case .universal, .space: ""
	 case .physics: "_physics"
	 }
  }

  //  Space overrides category to "space" instead of "science" for the same reason.
  var category: String {
	 switch self {
	 case .universal, .physics: ReadCategories.science.rawValue
	 case .space: "space"
	 }
  }

  var storeId: String? {
	 switch self {
	 case .universal, .space: nil
	 case .physics: "com.hiroio.tinyreads.subcategory.science.physics"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .physics: "Physics"
	 case .space: "Space"
	 }
  }

  var image: String {
	 switch self {
	 case .universal, .physics, .space: "ScienceStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 200
	 case .physics: 50
	 case .space: 100
	 }
  }
}
