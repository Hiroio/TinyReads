//
//  CategoryGrid.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI

struct CategoryGrid: View {
  @Environment(ThemeManager.self) var themeManager
  @Binding var gridState: Bool
  let action: (ReadCategories) -> ()
    var body: some View {
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridState ? 3 : 2)){
		  ForEach(ReadCategories.allCases){ category in
			 VStack(spacing: 0){
				Image("\(category.rawValue.capitalized)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
				  .resizable()
				  .scaledToFit()
				Text(category.title)
				  .font(.headline.weight(.bold))
			 }
			 .onTapGesture {
				action(category)
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

#Preview {
  CategoryGrid(gridState: .constant(false)){_ in}
	 .environment(ThemeManager())
}
