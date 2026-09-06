//
//  FinanceSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum FinanceSubCategory: String, ReadSubCategory {
  case universal, howMoneyWorks

  var id: String {
	 self == .universal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.finance.rawValue }

  var storeId: String? {
	 switch self {
	 case .universal: nil
	 case .howMoneyWorks: "com.hiroio.tinyreads.subcategory.finance.howMoneyWorks"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .universal: "Universal"
	 case .howMoneyWorks: "How Money Works"
	 }
  }

  var image: String {
	 switch self {
	 case .universal, .howMoneyWorks: "FinanceStore01Light"
	 }
  }

  var count: Int {
	 switch self {
	 case .universal: 200
	 case .howMoneyWorks: 50
	 }
  }
}
