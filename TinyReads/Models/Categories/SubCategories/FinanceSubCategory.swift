//
//  FinanceSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum FinanceSubCategory: String, ReadSubCategory {
  case financeUniversal, howMoneyWorks

  var id: String { rawValue }

  var idSuffix: String {
	 self == .financeUniversal ? "" : "_\(rawValue)"
  }

  var category: String { ReadCategories.finance.rawValue }

  var parentCategory: ReadCategories { .finance }

  var storeId: String? {
	 switch self {
	 case .financeUniversal: nil
	 case .howMoneyWorks: "com.hiroio.tinyreads.subcategory.finance.howMoneyWorks"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .financeUniversal: "Universal"
	 case .howMoneyWorks: "How Money Works"
	 }
  }

  var image: String {
	 switch self {
	 case .financeUniversal, .howMoneyWorks: "Finance"
	 }
  }

  var count: Int {
	 switch self {
	 case .financeUniversal: 200
	 case .howMoneyWorks: 50
	 }
  }
}
