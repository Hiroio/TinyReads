//
//  StoreView.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import SwiftUI
import StoreKit

struct StoreView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = StoreViewModel()

  var body: some View {
	 let assets = themeManager.themeAssets
	
	 VStack{
		Text("Store")
		  .title()
		HStack{
		  StoreSection(section: .categories)
		  
		  StoreSection(section: .tip)
		}
		.padding(.vertical)
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .padding()
	 .aspectRatio(1, contentMode: .fit)
	 .background(
		Image(assets.readerCard)
		  .resizable()
	 )
	 .padding()
	 
  }
}

#Preview {
  StoreView()
	 .environment(ThemeManager())
}


extension StoreView{
  func StoreSection(section: StoreSectionEnum) -> some View{
	 
	 VStack{
		Image(section.image)
		  .resizable()
		  .scaledToFit()
		
		Text(section.title)
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .padding()
	 .background(
		RoundedRectangle(cornerRadius: 10)
		  .stroke(lineWidth: 1)
	 )
  }
}
