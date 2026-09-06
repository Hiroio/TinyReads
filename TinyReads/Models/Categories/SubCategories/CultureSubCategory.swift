//
//  CultureSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum CultureSubCategory: String, ReadSubCategory {
  case universal, japan, rome, viking

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.culture.rawValue }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .japan: "com.hiroio.tinyreads.subcategory.culture.japan"
	 case .rome: ""
	 case .viking: ""
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .japan: "Japan"
	 case .rome: "Rome"
	 case .viking: "Vikings"
	 }
  }

  //  Test-only placeholders — reused Store icons, not final art.
  var image: String {
	 switch self {
	 case .universal: "PhilosophyStore01Light"
	 case .japan: "HistoryStore01Light"
	 case .rome: "FinanceStore01Light"
	 case .viking: "PsychologyStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 100
	 case .japan: 50
	 case .rome: 80
	 case .viking: 80
	 }
  }
}
