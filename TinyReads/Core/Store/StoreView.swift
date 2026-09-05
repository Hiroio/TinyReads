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
  @Environment(StoreKitManager.self) var storeKitManager
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

			 
		  case .tip:
			 TipStoreView()
				.transition(.move(edge: .trailing).combined(with: .opacity))
				.allowsHitTesting(vm.state == .tip)
				.drawingGroup()
		  default:
			 MainStoreView
				.transition(.scale.combined(with: .opacity))
				.zIndex(1)
				.allowsHitTesting(vm.state == nil)
		  }
		  
		  Button{
			 withAnimation {
				if vm.state != nil {
				  vm.state = nil
				}else{
				  NavigationManager.shared.secondary = nil
				}
			 }
		  }label:{
			 Text(vm.state == nil ? "Close" : "Back")
				.headline(weight: .light)
				.padding()
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
					 .shadow(radius: 3)
				)
				.drawingGroup()
		  }
		  .zIndex(2)
		}
	 }
  }
}

#Preview {
  StoreView()
	 .environment(ThemeManager())
	 .environment(StoreKitManager.shared)
}


extension StoreView{
  func StoreSection(section: StoreSectionEnum) -> some View{
	 VStack(spacing: 0){
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
			 .background(
				Image(themeManager.themeAssets.backCard)
				  .resizable()
				  .scaledToFit()
				  .scaleEffect( x: section == .tip ? 1 : -1)
			 )
			 .overlay(alignment: .bottom){
				Text(section.title)
				  .headline(weight: .light)
				  .padding(.bottom, UIDevice.isIPad ? 65 : 35)
				  .allowsTightening(true)
				  .minimumScaleFactor(0.6)
			 }
		}
		
	 }
  }
  
  
  
  private var MainStoreView: some View{
	 VStack(spacing: 5){
		Text("Tiny Store")
		  .font(.largeTitle.weight(.light))
		  .fontDesign(.serif)
		  .padding()
		  .padding(.horizontal)
		  .background(
			 Image(themeManager.themeAssets.backSmallCard)
				.resizable()
		  )
		HStack{
		  StoreSection(section: .categories)
		  
		  StoreSection(section: .tip)
		}
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .aspectRatio(1, contentMode: .fit)
	 .padding()
	 
  }
}
