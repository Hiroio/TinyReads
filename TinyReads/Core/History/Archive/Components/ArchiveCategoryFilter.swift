//
//  ArchiveCategoryFilter.swift
//  TinyReads
//
//  Created by user on 11.09.2026.
//

import SwiftUI

struct ArchiveCategoryFilter: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var vm: ArchiveViewModel
  var body: some View {
	 ScrollView{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
		  Button{
			 withAnimation{
				vm.selectedCategories.removeAll()
			 }
		  }label:{
			 VStack(spacing: 0){
				Image("AllBook\(themeManager.colorScheme == .light ? "Light" : "Dark")")
				  .resizable()
				  .scaledToFit()
				  .shadow(color: vm.selectedCategories.isEmpty ? themeManager.themeAssets.accent : .clear, radius: 5)
				Text("All")
				  .font(.headline.weight(.bold))
			 }
		  }
		  .buttonStyle(.plain)
		  
		  ForEach(ReadCategories.allCases){category in
			 let active = vm.selectedCategories.contains(category)
			 VStack(spacing: 0){
				Image("\(category.rawValue.capitalized)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
				  .resizable()
				  .scaledToFit()
				  .shadow(color: active ? themeManager.themeAssets.accent : .clear, radius: 5)
				  .shadow(color: active ? themeManager.themeAssets.accent : .clear, radius: 5)
				Text(category.title)
				  .font(.headline.weight(.bold))
			 }
			 .onTapGesture {
				withAnimation{
				  vm.selectCategory(category: category)
				}
			 }
		  }
		}
		.padding(5)
	 }
  }
}

#Preview {
  ArchiveCategoryFilter(vm: .init())
	 .environment(ThemeManager())
}
