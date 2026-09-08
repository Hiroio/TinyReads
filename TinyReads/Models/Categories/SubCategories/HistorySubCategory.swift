//
//  HistorySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HistorySubCategory: String, ReadSubCategory {
  case historyUniversal, ancientRome, egypt

  var id: String { rawValue }

  var idSuffix: String {
	 self == .historyUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.history.rawValue }

  var parentCategory: ReadCategories { .history }

  var storeId: String? {
	 switch self {
	 case .historyUniversal: nil
	 case .ancientRome: "com.hiroio.tinyreads.subcategory.history.ancientRome"
	 default: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .historyUniversal: "Universal"
	 case .ancientRome: "Ancient Rome"
	 case .egypt: "Ancient Egypt"
	 }
  }

  var image: String {
	 switch self {
	 case .historyUniversal : "History"
	 case .ancientRome: "Rome"
	 case .egypt: "Egypt"
	 }
  }

  var count: Int {
	 switch self {
	 case .historyUniversal: 200
	 case .ancientRome: 80
	 case .egypt: 80
	 }
  }
}
