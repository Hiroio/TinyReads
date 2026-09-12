//
//  CategoriesGrid.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI

struct CategoriesGrid: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = CategoriesViewModel()
  var body: some View {
	 VStack{
		Text(vm.selectedCategory?.title ?? "Categories")
		  .font(.title.weight(.black))
		  .padding(.bottom, 35)
		  .animation(.easeInOut, value: vm.selectedCategory != nil)
		GeometryReader { geo in
		  ScrollView(showsIndicators: false){
			 if let selectedCategory = vm.selectedCategory{
				SubCategoriesView(category: selectedCategory, vm: vm, minHeight: geo.size.height)
			 }else{
				CategoryGrid(gridState: $vm.gridState, minHeight: geo.size.height, action: vm.openCategory)
			 }
			 Button{
				Task{
				  await StoreKitManager.shared.restorePurchases(source: "categories")
				}
			 }label:{
				Text("Restore Purchases")
				  .foregroundStyle(themeManager.themeAssets.accent)
				  .font(.caption)
				  .underline()
				  .padding(.bottom)
			 }
		  }
		  .offset(y: vm.animate ? 0 : geo.size.height)
		  .scrollBounceBehavior(.basedOnSize)
		}
		.ignoresSafeArea(edges: .bottom)
	 }
	 .fontDesign(.serif)
	 .overlay(alignment: .top){
		actionHeader
	 }
  }
}

#Preview {
  CategoriesGrid()
	 .environment(ThemeManager())
}




extension CategoriesGrid{
  @ViewBuilder
  private var actionHeader: some View{
	 HStack{
		Group{
		  Button{
			 if vm.selectedCategory != nil{
				vm.openCategory(nil)
			 }else{
				NavigationManager.shared.secondary = nil
			 }
		  }label:{
			 Image(systemName: vm.selectedCategory != nil ? "chevron.left" : "xmark")
				.font(.title3)
				.padding(10)
		  }
		  
		  Spacer()
		  
		  Button{
			 vm.toggleGridState()
		  }label:{
			 Image(systemName: vm.gridState ? "rectangle.grid.3x2.fill" : "rectangle.grid.2x2.fill")
				.padding(10)
		  }
		}
		.background(
		  Image(themeManager.themeAssets.backSmallCard)
			 .resizable()
			 .shadow(radius: 1)
		)
		.padding(.horizontal)
		.foregroundStyle(themeManager.themeAssets.accent)
	 }
	 .animation(.easeInOut, value: vm.selectedCategory != nil)
  }
  
  
}

