//
//  CultureSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum CultureSubCategory: String, ReadSubCategory {
  case universal, japan

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .japan: "com.hiroio.tinyreads.subcategory.culture.japan"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .japan: "Japan"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 100
	 case .japan: 50
	 }
  }
}
