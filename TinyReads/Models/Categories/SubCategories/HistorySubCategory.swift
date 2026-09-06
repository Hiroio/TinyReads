//
//  HistorySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HistorySubCategory: String, ReadSubCategory {
  case universal, ancientRome

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.history.rawValue }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .ancientRome: "com.hiroio.tinyreads.subcategory.history.ancientRome"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .ancientRome: "Ancient Rome"
	 }
  }

  var image: String {
	 switch self {
	 case .universal, .ancientRome: "HistoryStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 200
	 case .ancientRome: 50
	 }
  }
}
