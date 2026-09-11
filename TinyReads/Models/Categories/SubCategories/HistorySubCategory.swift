//
//  HistorySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HistorySubCategory: String, ReadSubCategory {
  case historyUniversal, ancientRome, ancientEgypt

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
	 case .ancientEgypt: "com.hiroio.tinyreads.subcategory.history.ancientEgypt"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .historyUniversal: "Universal"
	 case .ancientRome: "Ancient Rome"
	 case .ancientEgypt: "Ancient Egypt"
	 }
  }

  var image: String {
	 switch self {
	 case .historyUniversal : "History"
	 case .ancientRome: "Rome"
	 case .ancientEgypt: "Egypt"
	 }
  }

  var count: Int {
	 switch self {
	 case .historyUniversal: 200
	 case .ancientRome: 80
	 case .ancientEgypt: 80
	 }
  }
}
