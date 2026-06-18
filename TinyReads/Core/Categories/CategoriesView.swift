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
			 .title()
			 .frame(maxWidth: .infinity)
			 .overlay(
				Button{
				  if secondary{
					 NavigationManager.shared.secondary = nil
				  }else{
					 onDismiss()
				  }
				}label: {
				  Image(systemName: "xmark")
					 .accent()
				}
				  .opacity(secondary ? 1 : 0),
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
		VStack(spacing: 10) {
		  ForEach(ReadCategories.allCases) { item in
			 categoryRow(item)
		  }
		}
		.padding(30)
		.frame(maxWidth: .infinity)
	 }
	 .scrollIndicators(.hidden)
	 .clipShape(.rect)
	 .frame(height: 450)
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
