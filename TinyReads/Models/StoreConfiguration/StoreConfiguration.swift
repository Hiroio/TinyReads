//
//  StoreConfiguration.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import SwiftUI

protocol StoreItems{}

enum StoreTipConfigurationEnum: String, CaseIterable, Identifiable, StoreItems{
  case smallTip
  case mediumTip
  case largeTip
  case extraLargeTip

  var id: String{
	 self.rawValue
  }
  
  var storeID: String{
	 switch self{
	 case .smallTip: "com.hiroio.tinyreads.tip.small"
	 case .mediumTip: "com.hiroio.tinyreads.tip.medium"
	 case .largeTip: "com.hiroio.tinyreads.tip.large"
	 case .extraLargeTip: "com.hiroio.tinyreads.tip.extraLarge"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .smallTip: "Small"
	 case .mediumTip: "Medium"
	 case .largeTip: "Large"
	 case .extraLargeTip: "XLarge"
	 }
  }

  var subtitle: LocalizedStringKey {
	 switch self {
	 case .smallTip: "A little thank-you"
	 case .mediumTip: "A generous tip"
	 case .largeTip: "A big thank-you"
	 case .extraLargeTip: "I'm sooo grateful"
	 }
  }

  var price: String {
	 switch self {
	 case .smallTip: "1$"
	 case .mediumTip: "2$"
	 case .largeTip: "5$"
	 case .extraLargeTip: "10$"
	 }
  }
}





enum StoreSectionEnum{
  case tip

  var title: LocalizedStringKey{
	 switch self {
	 case .tip:
		"Help Author"
	 }
  }

  var items: [StoreItems]{
	 switch self {
	 case .tip:
		StoreTipConfigurationEnum.allCases
	 }
  }

  var image: String{
	 switch self {
	 case .tip:
		"TipSection"
	 }
  }
}

