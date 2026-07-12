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
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: UIDevice.isIPad ? 2 : 1)){
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
			 Button{
				Task{
				  await storeKitManager.restorePurchases()
				}
			 }label: {
				Text("Restore Purchases")
				  .secondary(weight: .semibold)
				  .underline(true)
			 }
		  }
		  .padding(UIDevice.isIPad ? 45 : 25)
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
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
	 if UIDevice.isIPad {
		VStack{
		  categoryIcon(category, isPurchased: isPurchased)
		  categoryText(category)
		}
	 }else{
		HStack{
		  categoryIcon(category, isPurchased: isPurchased)
		  categoryText(category)
		}
	 }
  }
  
  
  private func categoryIcon(_ category: StoreCategoriesConfigurationEnum, isPurchased: Bool) -> some View{
	 ZStack{
		let themeIconStyle: String = themeManager.themeAssets == .dark ? "Dark" : "Light"
		Image(category.icon + themeIconStyle)
		  .resizable()
		  .scaledToFit()
		  .aspectRatio(1, contentMode: .fit)
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
			 .padding(UIDevice.isIPad ? 15 : 5)
			 .background( isPurchased ? .green : themeManager.themeAssets.accent, in: .circle)
			 .padding(.trailing)
			 .rotationEffect(Angle(degrees: -10))
		  }
	 }
  }
  
  
  private func categoryText(_ category: StoreCategoriesConfigurationEnum) -> some View{
	 VStack{
		Text(category.title)
		  .title(weight: .semibold)
		  .allowsTightening(true)
		  .lineLimit(1)
		  .minimumScaleFactor(0.7)
		Text(category.subtitle)
		  .secondary()
	 }
	 .frame(maxWidth: .infinity)
	 .shadow(color: themeManager.themeAssets.primary, radius: 0.5)
  }
}
