//
//  AppRootView.swift
//  TinyReads
//
//  Created by user on 23.06.2026.
//

import SwiftUI

struct AppRootView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefault
  @Environment(StoreKitManager.self) var storeKitManager
  @State private var cardSliderVM = CardSliderViewModel()
  var body: some View {
	 MainNavigationView()
		.environment(cardSliderVM)
		.preferredColorScheme(nil)
		.onAppear {
		  themeManager.colorScheme = colorScheme
		  themeManager.changeColorTheme()
		}
		.task {
		  let ids = StoreTipConfigurationEnum.allCases.map(\.storeID)
			 + StoreCategoriesConfigurationEnum.allCases.map(\.storeID)
		  await storeKitManager.loadProducts(ids: ids)
		}
//	 Purchases
		.onChange(of: storeKitManager.purchasedProductIDs) { _, _ in
		  Task{
			 await cardSliderVM.reloadCards()
		  }
		}
//	 Color theme
		.onChange(of: colorScheme) { _, newValue in
		  withAnimation {
			 themeManager.colorScheme = newValue
			 themeManager.changeColorTheme()
		  }
		}
//	 Language change
		.onChange(of: userDefault.selectedLanguage, { _, _ in
		  Task{
			 await cardSliderVM.reloadCards()
		  }
		})
//	 Categories
		.onChange(of: userDefault.selectedCategories, { _, _ in
		  Task{
			 await cardSliderVM.reloadCards()
		  }
		})
  }
}

#Preview {
  AppRootView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
	 .environment(StoreKitManager.shared)
}
