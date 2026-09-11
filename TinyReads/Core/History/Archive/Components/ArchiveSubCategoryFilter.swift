//
//  ArchiveSubCategoryFilter.swift
//  TinyReads
//
//  Created by user on 11.09.2026.
//

import SwiftUI

struct ArchiveSubCategoryFilter: View {
  @Environment(ThemeManager.self) var themeManager
  let vm: ArchiveViewModel
  //  Shared so a book flies between the two sections instead of blinking out and back in.
  @Namespace private var namespace

  private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

  var body: some View {
	 ScrollView{
		LazyVGrid(columns: columns, spacing: 10){
		  if !vm.selectedSubCategories.isEmpty{
			 Section{
				ForEach(vm.selectedSubCategories, id: \.id){ subCategory in
				  book(subCategory, selected: true)
				}
			 }header:{
				HStack{
				  sectionTitle("Selected")

				  Spacer()

				  Button{
					 withAnimation(.easeInOut){
						vm.clearSubCategoryFilter()
					 }
				  }label:{
					 Text("Clear all")
						.font(.footnote.weight(.bold))
						.foregroundStyle(themeManager.themeAssets.accent)
				  }
				}
			 }
		  }

		  Section{
			 ForEach(vm.availableSubCategories, id: \.id){ subCategory in
				book(subCategory, selected: false)
			 }
		  }header:{
			 HStack{
				sectionTitle(vm.selectedSubCategories.isEmpty ? "Filter by book" : "Available")
				Spacer()
			 }
		  }
		}
		.padding(2)
	 }
  }
}

#Preview {
	 ArchiveSubCategoryFilter(vm: ArchiveViewModel())
	 .environment(ThemeManager())
}


extension ArchiveSubCategoryFilter{
  private func sectionTitle(_ title: LocalizedStringKey) -> some View{
	 Text(title)
		.font(.footnote.weight(.black))
		.foregroundStyle(themeManager.themeAssets.secondary)
  }

  private func book(_ subCategory: any ReadSubCategory, selected: Bool) -> some View{
	 Button{
		withAnimation(.easeInOut){
		  vm.toggleSubCategory(subCategory)
		}
	 }label:{
		VStack(spacing: 0){
		  Image("\(subCategory.image)\(themeManager.colorScheme == .dark ? "Dark" : "Light")")
			 .resizable()
			 .scaledToFit()
			 .shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 5)
			 .shadow(color: selected ? themeManager.themeAssets.accent : .clear, radius: 5)
			 .overlay(alignment: .topTrailing){
				//  how many cards this book would leave on screen
				Text("\(vm.cardsCount(for: subCategory))")
				  .font(.caption2.weight(.bold))
				  .foregroundStyle(.white)
				  .padding(4)
				  .background(
					 RoundedRectangle(cornerRadius: 5)
						.fill(themeManager.themeAssets.accent)
				  )
				  .padding(5)
			 }

		  Text(subCategory.title)
			 .font(.footnote.weight(.black))
			 .frame(maxWidth: .infinity)
			 .foregroundStyle(themeManager.themeAssets.accent)
		}
		.matchedGeometryEffect(id: subCategory.id, in: namespace)
	 }
	 .buttonStyle(.plain)
  }
}
