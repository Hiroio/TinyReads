//
//  PsychologySubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum PsychologySubCategory: String, ReadSubCategory {
  case universal, cognitiveBiases

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.psychology.rawValue }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .cognitiveBiases: "com.hiroio.tinyreads.subcategory.psychology.cognitiveBiases"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .cognitiveBiases: "Cognitive Biases"
	 }
  }

  var image: String {
	 switch self {
	 case .universal, .cognitiveBiases: "PsychologyStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 200
	 case .cognitiveBiases: 50
	 }
  }
}
