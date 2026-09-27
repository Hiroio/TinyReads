//
//  FinanceSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum FinanceSubCategory: String, ReadSubCategory {
  case financeUniversal, howMoneyWorks, financialCrashes, personalFinance

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
	 case .financialCrashes: "com.hiroio.tinyreads.subcategory.finance.financialCrashes"
	 case .personalFinance: "com.hiroio.tinyreads.subcategory.finance.personalFinance"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .financeUniversal: "Universal"
	 case .howMoneyWorks: "How Money Works"
	 case .financialCrashes: "Financial Crashes"
	 case .personalFinance: "Personal Finance"
	 }
  }

  var image: String {
	 switch self {
	 case .financeUniversal: "Finance"
	 case  .howMoneyWorks: "MoneyWorks"
	 case .financialCrashes: "FinancialCrashes"
	 case .personalFinance: "PersonalFinance"
	 }
  }

  var count: Int {
	 switch self {
	 case .financeUniversal: 200
	 default: 80
	 }
  }
}
