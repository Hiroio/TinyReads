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
				Text("Donate")
				  .headline()
				  .minimumScaleFactor(0.45)
				  .frame(maxWidth: .infinity, alignment: .leading)
				Text(tip.price)
				  .font(.headline)
				  .accent(weight: .bold)
			 }
			 Text(tip.subtitle)
				.font(.caption2)
				.minimumScaleFactor(0.45)
				.foregroundStyle(themeManager.themeAssets.secondary)
		  }
		  .fontDesign(.serif)
		  .padding(.horizontal, UIDevice.isIPad ? 55 : 20)
		 
	 }
	 .aspectRatio(UIDevice.isIPad ? 1 : 0.7, contentMode: .fit)
  }
}
