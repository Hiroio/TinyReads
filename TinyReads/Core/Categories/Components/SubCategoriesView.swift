//
//  SubCategoriesView.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI
import StoreKit

struct SubCategoriesView: View {
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @Environment(ThemeManager.self) var themeManager
  let category: ReadCategories
  let vm: CategoriesViewModel
  var minHeight: CGFloat = 0
  var body: some View {
	 VStack{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: vm.gridState ? 3 : 2)){
		  ForEach(category.subCategories, id: \.id){ subCategory in
			 Button{
				vm.select(subCategory)
			 }label:{
				subCategoryView(subCategory: subCategory, selected: vm.isSelected(subCategory))
				  .foregroundStyle(themeManager.themeAssets.primary)
			 }
		  }
		}
		.padding(10)
		.padding(.bottom)
		.frame(minHeight: minHeight, alignment: .top)
		.background {
		  PaperBackGround()
			 .scaleEffect(x: 1.1)
		  //  paper runs past the content edge so it never ends before the screen does
			 .padding(.bottom, -60)
		}
		.geometryGroup()
	 }
	 .padding(.top)
  }
  
}

#Preview {
  SubCategoriesView(category: .culture, vm: CategoriesViewModel())
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}


extension SubCategoriesView{
  @ViewBuilder
  private func subCategoryView(subCategory: any ReadSubCategory, selected: Bool) -> some View{
	 VStack(spacing: 0){
		Image("\(subCategory.image)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
		  .resizable()
		  .scaledToFit()
		  .shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 5)
		  .shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 5)
		
		  .overlay(alignment: .topLeading) {
				HStack(spacing: 0){
				  Text("\(userDefaultManager.getCategoryReadedCount(for: subCategory))/")
				  Text("\(subCategory.count)")
				}
				.padding(5)
				.foregroundStyle(.white)
				.background(
				  RoundedRectangle(cornerRadius: 5)
					 .fill(themeManager.themeAssets.accent)
				)
				.font(.caption.weight(.bold))
				.padding(10)
		  }
		  .overlay(alignment: .bottomTrailing){
			 Group{
				if let price = vm.priceBadge(for: subCategory){
				  Text(price)
					 .padding(10)
				}
			 }
			 .foregroundStyle(.white)
			 .background(
				RoundedRectangle(cornerRadius: 5)
				  .fill(themeManager.themeAssets.accent)
			 )
			 .font(.caption.weight(.bold))
			 .padding(10)
			 .offset(y: -10)
			 }
			
		Text(subCategory.title)
		  .font(.headline.weight(.bold))
	 }
	 .foregroundStyle(themeManager.themeAssets.primary)
	 .fontDesign(.monospaced)
  }
}
