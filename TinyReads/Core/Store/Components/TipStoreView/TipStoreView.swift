//
//  TipStoreView.swift
//  TinyReads
//
//  Created by user on 08.07.2026.
//

import SwiftUI

struct TipStoreView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(StoreKitManager.self) var storeKitManager
    var body: some View {
		  VStack{
			 LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10){
				ForEach(StoreTipConfigurationEnum.allCases){item in
				  Button{
					 guard let product = storeKitManager.product(for: item.storeID) else { return }
					 Task { await storeKitManager.purchase(product) }
				  }label:{
					 TipStoreItem(item)
				  }
				  .disabled(storeKitManager.purchasingProductID == item.storeID)
				}
			 }
			 .padding(.horizontal)
		  }
		  .padding(.horizontal, 25)
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  .aspectRatio(UIDevice.isIPad ? 0.9 : 0.7, contentMode: .fit)
		  .background(
			 Image(themeManager.themeAssets.backCard)
				.resizable(resizingMode: .stretch)
				.shadow(radius: 5)
		  )
    }
}

#Preview {
    TipStoreView()
	 .environment(ThemeManager())
	 .environment(StoreKitManager.shared)
}


extension TipStoreView{
  
  
  @ViewBuilder
  func TipStoreItem(_ tip: StoreTipConfigurationEnum) -> some View{
	 let themeIconStyle: String = themeManager.themeAssets == .dark ? "Dark" : "Light"
	 VStack(spacing: 0){
		Image(tip.id + themeIconStyle)
		  .resizable()
		  .scaledToFit()
		  .shadow(color: themeManager.themeAssets.primary, radius: 1)
		  VStack(alignment: .leading){
			 HStack{
				Text(tip.title)
				  .title()
				  .fixedSize()
				Text(tip.price)
				  .font(.title3)
				  .accent(weight: .bold)
				  .fontDesign(.serif)
				  .frame(maxWidth: .infinity, alignment: .trailing)
			 }
			 Text(tip.subtitle)
				.secondary()
		  }
		  .padding(.horizontal)
		 
	 }
	 .aspectRatio(0.7, contentMode: .fit)
  }
}
