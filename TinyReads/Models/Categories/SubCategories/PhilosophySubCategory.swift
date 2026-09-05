//
//  PhilosophySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum PhilosophySubCategory: String, ReadSubCategory {
  case universal, stoicism

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .stoicism: "com.hiroio.tinyreads.subcategory.philosophy.stoicism"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .stoicism: "Stoicism"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 200
	 case .stoicism: 50
	 }
  }
}
