//
//  TipStoreView.swift
//  TinyReads
//
//  Created by user on 08.07.2026.
//

import SwiftUI

struct TipStoreView: View {
  @Environment(ThemeManager.self) var themeManager
    var body: some View {
		  VStack{
			 LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10){
				ForEach(StoreTipConfigurationEnum.allCases){item in
				  Button{}label:{
					 VStack(spacing: 0){
						Image(item.id)
						  .resizable()
						  .scaledToFit()
						  VStack(alignment: .leading){
							 HStack{
								Text(item.title)
								  .title()
								  .fixedSize()
								Text(item.price)
								  .font(.title3)
								  .accent(weight: .bold)
								  .fontDesign(.serif)
								  .frame(maxWidth: .infinity, alignment: .trailing)
							 }
							 Text(item.subtitle)
								.secondary()
						  }
						  .padding(.horizontal)
						 
					 }
					 .aspectRatio(0.7, contentMode: .fit)
				  }
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
		  )
		  .shadow(radius: 5)
    }
}

#Preview {
    TipStoreView()
	 .environment(ThemeManager())
}
