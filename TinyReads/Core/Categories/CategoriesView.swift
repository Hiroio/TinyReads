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
  let secondary: Bool
  init(secondary: Bool = false){
	 self.secondary = secondary
  }
  var body: some View {
		ZStack{
		  let assets = themeManager.themeAssets
		  
		  assets.background.ignoresSafeArea()
		  VStack{
			 Text("Select Your Interests")
				.title()
			 ScrollView{
				LazyVGrid(columns: Array(repeating: .init(spacing: 20), count: 2), spacing: 0) {
				  ForEach(ReadCategories.allCases){item in
					 let active = userDefaults.selectedCategories.contains(item.rawValue)
					 Button{
						userDefaults.toggleCategory(item)
					 }label:{
						Text(item.rawValue.capitalized)
						  .font(.title3.weight(.medium))
						  .fontDesign(.serif)
						  .foregroundStyle( active ? assets.accent : assets.primary )
						  .frame(maxWidth: .infinity, maxHeight: .infinity)
						  .aspectRatio(1, contentMode: .fit)
						  .background(
							 Image("backGroundCard")
								.resizable()
								.scaledToFill()
								.shadow(color: assets.accent, radius: active ? 10 : 0)
						  )
						  .scaleEffect(active ? 1.05 : 1)
						  .geometryGroup()
						  .padding()
						  .contentShape(.rect)
					 }
				  }
				}
				.padding(.horizontal)
			 }
		  }
		  .overlay(
				Button{
				  NavigationManager.shared.secondary = nil
				}label: {
				  Image(systemName: "chevron.left")
					 .font(.headline.weight(.light))
					 .foregroundStyle(assets.primary)
					 .padding(.horizontal)
				}
				  .opacity(secondary ? 1 : 0)
				  .allowsHitTesting(secondary)
				,
				alignment: .topLeading
		  )
		}
    }
  
  func addCategory(_ item: ReadCategories){
	 var array = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] ?? []
	 if array.contains(item.rawValue){
		array.removeAll(where: {$0 == item.rawValue})
	 }else{
		array.append(item.rawValue)
	 }
	 
	 self.userDefaults.selectedCategories = array
  }
}

#Preview {
    CategoriesView(secondary: true)
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
