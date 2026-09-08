//
//  SubCategoriesView.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI

struct SubCategoriesView: View {
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @Environment(ThemeManager.self) var themeManager
  let category: ReadCategories
  @Binding var gridState: Bool
    var body: some View {
		VStack{
		  LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridState ? 3 : 2)){
			 ForEach(category.subCategories, id: \.id){ subCategory in
				let selected = userDefaultManager.selectedSubCategories.contains(subCategory.id)
				Button{
				  selectCategory(subCategoryId: subCategory.id)
				}label:{
				  VStack(spacing: 0){
					 Image("\(subCategory.image)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
						.resizable()
						.scaledToFit()
						.shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 2)
						.shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 2)
					 Text(subCategory.title)
						.font(.headline.weight(.bold))
				  }
				  .foregroundStyle(themeManager.themeAssets.primary)
				}
			 }
		  }
		  .padding(10)
		  .padding(.bottom)
		  .background {
			 PaperBackGround()
				.scaleEffect(x: 1.1)
		  }
		  .geometryGroup()
		}
    }
  
  private func selectCategory(subCategoryId: String){
	 if userDefaultManager.selectedSubCategories.contains(subCategoryId){
		userDefaultManager.selectedSubCategories.removeAll(where: {$0 == subCategoryId})
	 }else{
		userDefaultManager.selectedCategories.append(subCategoryId)
	 }
  }
}

#Preview {
  SubCategoriesView(category: .culture, gridState: .constant(false))
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
