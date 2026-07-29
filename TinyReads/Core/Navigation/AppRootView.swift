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
//	 Widget deep link
		.onOpenURL { url in
		  guard url.scheme == "tinyreads" else { return }
		  let id = URLComponents(url: url, resolvingAgainstBaseURL: false)?
			 .queryItems?.first(where: { $0.name == "id" })?.value

		  switch url.host {
		  case "article":
			 guard let id else { return }
			 Task {
				guard let article = try? await FireStoreService.shared.fetchReads(ids: [id]).first else { return }
				NavigationManager.shared.article = ArticleRoute(
				  article: article,
				  onInteractionChanged: {},
				  isAbleToInteract: .fresh
				)
			 }
		  case "highlight":
			 guard let id, let highlightId = UUID(uuidString: id),
					 let entity = HighlightManager.shared.fetchSingleHighlight(id: highlightId) else {
				NavigationManager.shared.secondary = .highlight
				return
			 }
			 NavigationManager.shared.secondary = .highlight
			 NavigationManager.shared.highlight = .idle(HighlightModel(entity: entity))
		  default:
			 break
		  }
		}
  }
}

#Preview {
  AppRootView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
	 .environment(StoreKitManager.shared)
}
