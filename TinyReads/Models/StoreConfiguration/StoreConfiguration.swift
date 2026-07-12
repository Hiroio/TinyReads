//
//  StoreConfiguration.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import SwiftUI

protocol StoreItems{}

enum StoreCategoriesConfigurationEnum: String, CaseIterable, Identifiable, StoreItems{
  case sciencePack
  case historyPack
  case psychologyPack
  case philosophyPack
  case financePack

  var id: String{
	 self.rawValue
  }

  var storeID: String{
	 switch self{
	 case .sciencePack: "com.hiroio.tinyreads.category.science"
	 case .historyPack: "com.hiroio.tinyreads.category.history"
	 case .financePack: "com.hiroio.tinyreads.category.finance"
	 case .philosophyPack: "com.hiroio.tinyreads.category.philosophy"
	 case .psychologyPack: "com.hiroio.tinyreads.category.psychology"
	 }
  }

  var title: LocalizedStringKey {
	 switch self {
	 case .sciencePack: "Science Pack"
	 case .historyPack: "History Pack"
	 case .psychologyPack: "Psychology Pack"
	 case .philosophyPack: "Philosophy Pack"
	 case .financePack: "Finance Pack"
	 }
  }

  var subtitle: LocalizedStringKey {
	 switch self {
	 case .sciencePack: "100 more science cards to explore"
	 case .historyPack: "100 more history cards to explore"
	 case .psychologyPack: "100 more psychology cards to explore"
	 case .philosophyPack: "100 more philosophy cards to explore"
	 case .financePack: "100 more finance cards to explore"
	 }
  }

  var price: String {
	 switch self {
	 case .sciencePack: "3$"
	 case .historyPack: "3$"
	 case .psychologyPack: "3$"
	 case .philosophyPack: "3$"
	 case .financePack: "3$"
	 }
  }

  var icon: String {
	 switch self {
	 case .sciencePack: "ScienceStore01"
	 case .historyPack: "HistoryStore01"
	 case .psychologyPack: "PsychologyStore01"
	 case .philosophyPack: "PhilosophyStore01"
	 case .financePack: "FinanceStore01"
	 }
  }
}

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
  case categories, tip
  
  var title: LocalizedStringKey{
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

