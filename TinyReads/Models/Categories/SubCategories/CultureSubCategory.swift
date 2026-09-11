//
//  CultureSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum CultureSubCategory: String, ReadSubCategory {
  case cultureUniversal, japan, france

  var id: String { rawValue }

  var idSuffix: String {
	 self == .cultureUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.culture.rawValue }

  var parentCategory: ReadCategories { .culture }

  var storeId: String? {
	 switch self {
	 case .cultureUniversal: nil
	 case .japan: "com.hiroio.tinyreads.subcategory.culture.japan"
	 case .france: "com.hiroio.tinyreads.subcategory.culture.france"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .cultureUniversal: "Universal"
	 case .japan: "Japan"
	 case .france: "France"
	 }
  }

  var image: String {
	 switch self {
	 case .cultureUniversal: "Culture"
	 case .japan: "Japan"
	 case .france: "French"
	 }
  }

  var count: Int {
	 switch self {
	 case .cultureUniversal: 100
	 case .japan: 80
	 case .france: 80
	 }
  }
}
