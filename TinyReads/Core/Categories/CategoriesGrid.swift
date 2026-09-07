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
    var body: some View {
		VStack{
		  ScrollView(showsIndicators: false){
			 Text("Categories")
				.font(.title.weight(.black))
				.padding(.bottom, 35)
			 
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridState ? 3 : 2)){
				ForEach(ReadCategories.allCases){ category in
				  VStack(spacing: 0){
					 Image("\(category.rawValue.capitalized)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
						.resizable()
						.scaledToFit()
					 Text(category.title)
						.font(.headline.weight(.bold))
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
			 .offset(y: animate ? 0 : 1000)
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
				Image(systemName: "xmark")
				  .padding(10)
				
				Spacer()
				
				Button{
				  withAnimation{
					 gridState.toggle()
				  }
				}label:{
				  Image(systemName: gridState ? "rectangle.grid.3x2.fill" : "rectangle.grid.2x2.fill")
					 .foregroundStyle(themeManager.themeAssets.accent)
					 .padding(10)
				}
			 }
			 .background(
				Image(themeManager.themeAssets.backSmallCard)
				  .resizable()
				  .shadow(radius: 1)
			 )
			 .padding(.horizontal)
		  }
		}
    }
}

#Preview {
    CategoriesGrid()
	 .environment(ThemeManager())
}
