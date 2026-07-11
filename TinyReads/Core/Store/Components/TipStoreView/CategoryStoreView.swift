//
//  CategoryStoreView.swift
//  TinyReads
//
//  Created by user on 08.07.2026.
//

import SwiftUI

struct CategoryStoreView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(StoreKitManager.self) var storeKitManager
  var body: some View {
	 VStack{
		ScrollView{
		  LazyVStack{
			 ForEach(StoreCategoriesConfigurationEnum.allCases){item in
				Button{
				  guard let product = storeKitManager.product(for: item.storeID) else { return }
				  Task { await storeKitManager.purchase(product) }
				}label:{
				  CategoryStoreItem(item)
				}
				.disabled(storeKitManager.purchasingProductID == item.storeID || storeKitManager.isPurchased(item.storeID))
			 }
			 .padding(.horizontal)

		  }
		  .padding(25)
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  //		.aspectRatio(UIDevice.isIPad ? 0.9 : 0.7, contentMode: .fit)
		  .background(
			 PaperBackGround()
				.shadow(radius: 5)
		  )
		}
		.scrollClipDisabled()
	 }
  }
}

#Preview {
	CategoryStoreView()
	  .environment(ThemeManager())
	  .environment(StoreKitManager.shared)
}


extension CategoryStoreView{
  @ViewBuilder
  func CategoryStoreItem(_ category: StoreCategoriesConfigurationEnum) -> some View{
	 let isPurchased = storeKitManager.isPurchased(category.storeID)
	 HStack{
		let themeIconStyle: String = themeManager.themeAssets == .dark ? "Dark" : "Light"
		  Image(category.icon + themeIconStyle)
			 .resizable()
			 .scaledToFit()
			 .shadow(color: themeManager.themeAssets.primary, radius: 0.5)
			 .overlay(alignment: .topTrailing){
				Group{
				  if isPurchased{
					 Image(systemName: "checkmark")
						.font(.title2.weight(.semibold))
				  }else{
					 Text(category.price)
						.font(.title2.weight(.semibold))
						.fontDesign(.serif)
				  }
				}
				.foregroundStyle(.white)
				.padding(5)
				.background( isPurchased ? .green : themeManager.themeAssets.accent, in: .circle)
				.padding(.trailing)
				.rotationEffect(Angle(degrees: -10))
			 }
		VStack{
		  Text(category.title)
			 .title(weight: .semibold)
			 .allowsTightening(true)
			 .lineLimit(1)
			 .minimumScaleFactor(0.7)
		  Text(category.subtitle)
			 .secondary()
		}
		.shadow(color: themeManager.themeAssets.primary, radius: 0.5)
	 }
  }
}
