//
//  PhilosophySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum PhilosophySubCategory: String, ReadSubCategory {
  case philosophyUniversal, stoicism, existentialism

  var id: String { rawValue }

  var idSuffix: String {
	 self == .philosophyUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.philosophy.rawValue }

  var parentCategory: ReadCategories { .philosophy }

  var storeId: String? {
	 switch self {
	 case .philosophyUniversal: nil
	 case .stoicism: "com.hiroio.tinyreads.subcategory.philosophy.stoicism"
	 case .existentialism: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .philosophyUniversal: "Universal"
	 case .stoicism: "Stoicism"
	 case .existentialism: "Existentialism"
	 }
  }

  var image: String {
	 switch self {
	 case .philosophyUniversal: "Philosophy"
	 case .stoicism: "Stoicism"
	 case .existentialism: "Existentialism"
	 }
  }

  var count: Int {
	 switch self {
	 case .philosophyUniversal: 200
	 case .stoicism: 80
	 case .existentialism: 80
	 }
  }
}
