//
//  PhilosophySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum PhilosophySubCategory: String, ReadSubCategory {
  case philosophyUniversal, stoicism, existentialism, easternPhilosophy

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
	 case .existentialism: "com.hiroio.tinyreads.subcategory.philosophy.existentialism"
	 case .easternPhilosophy: "com.hiroio.tinyreads.subcategory.philosophy.easternPhilosophy"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .philosophyUniversal: "Universal"
	 case .stoicism: "Stoicism"
	 case .existentialism: "Existentialism"
	 case .easternPhilosophy: "Eastern Philosophy"
	 }
  }

  var image: String {
	 switch self {
	 case .philosophyUniversal: "Philosophy"
	 case .stoicism: "Stoicism"
	 case .existentialism: "Existentialism"
	 case .easternPhilosophy: "EasternPhilosophy"
	 }
  }

  var count: Int {
	 switch self {
	 case .philosophyUniversal: 200
	 case .stoicism: 80
	 case .existentialism: 80
	 case .easternPhilosophy: 80
	 }
  }
}
