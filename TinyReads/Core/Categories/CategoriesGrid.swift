//
//  CategoriesGrid.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI

struct CategoriesGrid: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var animate = false
  @State private var gridState: Bool = false
  @State private var selectedCategory: ReadCategories? = nil
    var body: some View {
		VStack{
		  ScrollView(showsIndicators: false){
			 Text("Categories")
				.font(.title.weight(.black))
				.padding(.bottom, 35)
			 
			 if let selectedCategory{
				SubCategoriesView(category: selectedCategory, gridState: $gridState)
				  .offset(y: animate ? 0 : 1000)
			 }else{
				CategoryGrid(gridState: $gridState, action: animateCategory)
				.transition(.move(edge: .bottom))
				.offset(y: animate ? 0 : 1000)
			 }
		  }
		}
		.fontDesign(.serif)
		.onAppear {
		  withAnimation {
			 animate.toggle()
		  }
		}
		.overlay(alignment: .top){
		  HStack{
			 Group{
				Button{
				  animateCategory(category: nil)
				}label:{
				  Image(systemName: selectedCategory != nil ? "chevron.left" : "xmark")
					 .padding(10)
				}
				
				Spacer()
				
				Button{
				  withAnimation{
					 gridState.toggle()
				  }
				}label:{
				  Image(systemName: gridState ? "rectangle.grid.3x2.fill" : "rectangle.grid.2x2.fill")
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
		}
		.animation(.easeInOut, value: selectedCategory == nil)
    }
  
  private func animateCategory(category: ReadCategories?){
	 Task{
		withAnimation(.easeInOut(duration: 0.3)){
		  animate = false
		}
		try await Task.sleep(for: .seconds(0.2))
		actionWithCategory(category: category)
		try await Task.sleep(for: .seconds(0.05))
		
		withAnimation(.easeInOut(duration: 0.4)) {
		  animate = true
		}
	 }
  }
  
  func actionWithCategory(category: ReadCategories?){
	 selectedCategory = category
  }
}

#Preview {
    CategoriesGrid()
	 .environment(ThemeManager())
}
