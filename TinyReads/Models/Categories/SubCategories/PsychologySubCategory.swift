//
//  PsychologySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum PsychologySubCategory: String, ReadSubCategory {
  case psychologyUniversal, cognitiveBiases, trauma

  var id: String { rawValue }

  var idSuffix: String {
	 self == .psychologyUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.psychology.rawValue }

  var parentCategory: ReadCategories { .psychology }

  var storeId: String? {
	 switch self {
	 case .psychologyUniversal: nil
	 case .cognitiveBiases: "com.hiroio.tinyreads.subcategory.psychology.cognitiveBiases"
	 case .trauma: "com.hiroio.tinyreads.subcategory.psychology.trauma"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .psychologyUniversal: "Universal"
	 case .cognitiveBiases: "Cognitive Biases"
	 case .trauma: "Trauma"
	 }
  }

  var image: String {
	 switch self {
	 case .psychologyUniversal: "Psychology"
	 case .cognitiveBiases: "Cognitive"
	 case .trauma: "Trauma"
	 }
  }

  var count: Int {
	 switch self {
	 case .psychologyUniversal: 200
	 case .cognitiveBiases: 80
	 case .trauma: 80
	 }
  }
}
