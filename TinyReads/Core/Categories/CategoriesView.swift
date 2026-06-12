//
//  CategoriesView.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import SwiftUI

struct CategoriesView: View {
  @Environment(UserDefaultsManager.self) var userDefaults
  @Environment(ThemeManager.self) var themeManager
  @Environment(NavigationManager.self) var navigationManager
  
  let secondary: Bool
  
  init(secondary: Bool = false){
	 self.secondary = secondary
  }
  
  var body: some View {
	 ZStack(alignment: .topLeading) {
		
		VStack(spacing: 24) {
		  Text("Select Your Interests")
			 .title()
			 .frame(maxWidth: .infinity)
			 .overlay(
				Button{
				  NavigationManager.shared.secondary = nil
				}label: {
				  Image(systemName: "xmark")
					 .accent()
				},
				alignment: .leading
			 )
			 .padding()
		  
		  categoryList
		}
		.padding()
		.padding(.top, 20)
		.background {
		  Image(themeManager.themeAssets.backCard)
			 .resizable()
			 .allowsHitTesting(false)
		}
	 }
	 .animation(.easeInOut, value: userDefaults.selectedCategories)
    }
}

// MARK: - Components
private extension CategoriesView {
  // Categories title list
  var categoryList: some View {
	 ScrollView {
		VStack(spacing: 18) {
		  ForEach(ReadCategories.allCases) { item in
			 categoryRow(item)
		  }
		}
		.padding()
		.frame(maxWidth: .infinity)
	 }
	 .scrollIndicators(.hidden)
	 .clipShape(.rect)
	 .scaledToFit()
	 .frame(height: 450)
  }
  
  // Category title
  func categoryRow(_ item: ReadCategories) -> some View {
	 let assets = themeManager.themeAssets
	 let active = userDefaults.selectedCategories.contains(item.rawValue)
	 
	 return Button {
		userDefaults.toggleCategory(item)
	 } label: {
		Text(item.rawValue.capitalized)
		  .font(.title2.weight(.medium))
		  .fontDesign(.serif)
		  .strikethrough(!active, color: assets.secondary)
		  .foregroundStyle(active ? assets.accent : assets.secondary)
		  .opacity(active ? 1 : 0.55)
		  .frame(maxWidth: .infinity)
		  .padding(.vertical, 4)
		  .contentShape(.rect)
	 }
	 .buttonStyle(.plain)
  }
}

#Preview {
    CategoriesView(secondary: true)
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
}
