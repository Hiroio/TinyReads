//
//  HealthSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum HealthSubCategory: String, ReadSubCategory {
  case universal

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.health.rawValue }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 }
  }

  //  No dedicated Health store icon yet — placeholder until real art exists.
  var image: String {
	 switch self {
	 case .universal: "ScienceStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 100
	 }
  }
}
