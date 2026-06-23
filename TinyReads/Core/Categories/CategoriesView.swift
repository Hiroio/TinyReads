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
  let onDismiss: () -> ()
  
  init(secondary: Bool = true, onDismiss: @escaping () -> () = {}){
	 self.secondary = secondary
	 self.onDismiss = onDismiss
  }
  
  var body: some View {
	 ZStack(alignment: .topLeading) {
		
		VStack(spacing: 24) {
		  Text("Select Your Interests")
			 .padding(.top)
			 .title()
			 .frame(maxWidth: .infinity)
			 .padding()
		  
		  categoryList
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(UIDevice.isIPad ? 1 : 0.7, contentMode: .fit)
		.background {
		  Image(themeManager.themeAssets.backCard)
			 .resizable()
			 .allowsHitTesting(false)
		}
		.overlay(
		  Button{
			 if secondary{
				NavigationManager.shared.secondary = nil
			 }else{
				onDismiss()
			 }
		  }label: {
			 Text("Close")
				.accent()
				.padding()
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
				)
		  }
			 .opacity(secondary ? 1 : 0),
		  alignment: .bottom
		)
		.padding(.horizontal)
		.shadow(radius: 5)
	 }
	 .animation(.easeInOut, value: userDefaults.selectedCategories)
  }
}

// MARK: - Components
private extension CategoriesView {
  // Categories title list
  var categoryList: some View {
	 ScrollView {
		VStack(spacing: 10) {
		  ForEach(ReadCategories.allCases) { item in
			 categoryRow(item)
		  }
		}
	 }
	 .frame(maxWidth: .infinity)
	 .scrollIndicators(.hidden)
	 .clipShape(.rect)
	 .aspectRatio(UIDevice.isIPad ? 0.9 : 0.6, contentMode: .fit)
  }
  
  // Category title
  func categoryRow(_ item: ReadCategories) -> some View {
	 let assets = themeManager.themeAssets
	 let active = userDefaults.selectedCategories.contains(item.rawValue)
	 
	 return Button {
		userDefaults.toggleCategory(item)
	 } label: {
		HStack(alignment: .bottom, spacing: 0){
		  Text(item.title)
			 .fixedSize()
		  Rectangle()
			 .stroke(style: StrokeStyle(
				lineWidth: 1.0,
				lineCap: .round,
				lineJoin: .miter,
				dash: [2, 10],
				dashPhase: 0))
			 .frame(height: 1)
		  
		  Text("\(userDefaults.getCategoryReadedCount(for: item))/\(item.limit)")
			 .fixedSize()
			 .secondary()
		}
		.font(.title2.weight(.light))
		.fontDesign(.serif)
		.strikethrough(!active, color: assets.secondary)
		.foregroundStyle(active ? assets.accent : assets.secondary)
		.opacity(active ? 1 : 0.55)
		.frame(maxWidth: .infinity)
		.contentShape(.rect)
		.padding(.horizontal)
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
