//
//  CategoryGrid.swift
//  TinyReads
//
//  Created by user on 07.09.2026.
//

import SwiftUI

struct CategoryGrid: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefault
  @Binding var gridState: Bool
  var minHeight: CGFloat = 0
  let action: (ReadCategories) -> ()
    var body: some View {
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridState ? 3 : 2)){
		  ForEach(ReadCategories.allCases){ category in
			 let active = category.subCategories.contains(where: { userDefault.selectedSubCategories.contains($0.id) })
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
				action(category)
			 }
		  }
		}
		.padding(25)
		.frame(minHeight: minHeight, alignment: .top)
		.background {
		  PaperBackGround()
			 .scaleEffect(x: 1.1)
			 //  paper runs past the content edge so it never ends before the screen does
			 .padding(.bottom, -60)
		}
		.geometryGroup()
    }
}

#Preview {
  CategoryGrid(gridState: .constant(false)){_ in}
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
