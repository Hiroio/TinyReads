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
	 ZStack{
		VStack{
		  switch vm.state {
		  case .categories:
			 CategoryStoreView()
				.transition(.move(edge: .leading).combined(with: .opacity))
				.zIndex(1)
				.allowsHitTesting(vm.state == .categories)
				.drawingGroup()
			 
		  case .tip:
			 TipStoreView()
				.transition(.move(edge: .trailing).combined(with: .opacity))
				.zIndex(1)
				.allowsHitTesting(vm.state == .tip)
				.drawingGroup()
		  default:
			 MainStoreView
				.transition(.scale.combined(with: .opacity))
				.zIndex(1)
				.allowsHitTesting(vm.state == nil)
		  }
		  
		  if vm.state != nil{
		  Button{
			 withAnimation {
				vm.state = nil
			 }
		  }label:{
			 Text("Back")
				.secondary()
				.padding()
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
					 .scaledToFit()
				)
		  }
		  .transition(.move(edge: .bottom).combined(with: .opacity))
		  }
		}
	 }
  }
}

#Preview {
  StoreView()
	 .environment(ThemeManager())
}


extension StoreView{
  func StoreSection(section: StoreSectionEnum) -> some View{
	 Button{
		withAnimation(){
		  vm.state = section
		}
	 }label:{
		  Image(section.image)
			 .resizable()
			 .scaledToFit()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(0.7, contentMode: .fit)
	 }
  }
  
  
  
  private var MainStoreView: some View{
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
		Image(themeManager.themeAssets.readerCard)
		  .resizable()
	 )
	 .padding()
	 
  }
}
