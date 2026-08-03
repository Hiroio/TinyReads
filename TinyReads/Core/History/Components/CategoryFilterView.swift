//
//  CategoryFilterView.swift
//  TinyReads
//
//  Created by user on 23.06.2026.
//

import SwiftUI

struct CategoryFilterView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var filterActive: Bool = false
  let categories: [String] = ["All"] + ReadCategories.allCases.map({$0.rawValue.capitalized})
  @Binding var selectedFilter: String
    var body: some View {
		Button{
		  withAnimation(.easeInOut){
			 filterActive.toggle()
		  }
		}label:{
		  Text(displayText(for: selectedFilter))
			 .accent()
		}
		  .overlay(alignment: .topTrailing){
			 VStack(alignment: .leading){
					 ForEach(categories, id: \.self){ item in
						Button{
						  withAnimation{
							 selectedFilter = item
							 filterActive = false
						  }
						}label: {
						  Text(displayText(for: item))
							 .font(.caption)
							 .fontDesign(.serif)
							 .foregroundStyle(selectedFilter == item ? themeManager.themeAssets.accent : themeManager.themeAssets.secondary)
							 .padding(8)
							 .frame(maxWidth: .infinity)
							 .contentShape(.rect)
							 .fixedSize()

						}
					 }
				  }
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(themeManager.themeAssets.card.opacity(0.8))
				  )
				  .offset(y: 20)
				  .opacity(filterActive ? 1 : 0)
				}
    }

  private func displayText(for category: String) -> LocalizedStringKey {
	 guard category != "All" else { return "All" }
	 return ReadCategories(rawValue: category.lowercased())?.title ?? LocalizedStringKey(category)
  }
}

#Preview {
  CategoryFilterView(selectedFilter: .constant("All"))
	 .environment(ThemeManager())
}
