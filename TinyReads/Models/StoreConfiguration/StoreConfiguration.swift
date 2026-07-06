//
//  StoreConfiguration.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import Foundation

protocol StoreItems{}

enum StoreCategoriesConfigurationEnum: String, CaseIterable, Identifiable, StoreItems{
  case test = ""
  
  var id: String { self.rawValue}
}

enum StoreTipConfigurationEnum: String, CaseIterable, Identifiable, StoreItems{
  case smallTip = "com.hiroio.tinyreads.tip.small"
  case mediumTip = "com.hiroio.tinyreads.tip.medium"
  case largeTip = "com.hiroio.tinyreads.tip.large"
  case extraLargeTip = "com.hiroio.tinyreads.tip.extraLarge"

  var id: String{
	 self.rawValue
  }

  var title: String {
	 switch self {
	 case .smallTip: "Small Tip"
	 case .mediumTip: "Medium Tip"
	 case .largeTip: "Large Tip"
	 case .extraLargeTip: "Extra Large Tip"
	 }
  }

  var subtitle: String {
	 switch self {
	 case .smallTip: "A little thank-you"
	 case .mediumTip: "A generous tip"
	 case .largeTip: "A big thank-you"
	 case .extraLargeTip: "This means the world to us"
	 }
  }

  var icon: String {
	 switch self {
	 case .smallTip: "heart"
	 case .mediumTip: "heart.fill"
	 case .largeTip: "gift.fill"
	 case .extraLargeTip: "crown.fill"
	 }
  }
}





enum StoreSectionEnum{
  case categories, tip
  
  var title: String{
	 switch self {
	 case .categories:
		"Categories"
	 case .tip:
		"Help Author"
	 }
  }
  
  var items: [StoreItems]{
	 switch self {
	 case .categories:
		StoreCategoriesConfigurationEnum.allCases
	 case .tip:
		StoreTipConfigurationEnum.allCases
	 }
  }
  
  var image: String{
	 switch self {
	 case .categories:
		"CategorySection"
	 case .tip:
		"TipSection"
	 }
  }
}

