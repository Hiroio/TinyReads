//
//  CategoryView.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

struct CategoryView: View {
  @Environment(ThemeManager.self) var themeManager
  let category: ReadCategories
  private let mockItems = ["Universal", "Item 2", "Item 3"]

  //  Real-content shelf variants, cycled through for visual variety.
  private let middleShelfAssets = ["CategoriesMiddle4", "CategoriesMiddle5"]

  //  Groups mock items 2-per-shelf; last shelf may have only 1 item.
  private var shelvesOfItems: [[String?]] {
	 var result: [[String?]] = []
	 var remaining = mockItems[...]
	 while !remaining.isEmpty {
		let pair = Array(remaining.prefix(2))
		result.append(pair.count == 2 ? [pair[0], pair[1]] : [pair[0], nil])
		remaining = remaining.dropFirst(pair.count)
	 }
	 return result
  }

  var body: some View {
	 ZStack{
		VStack {
		  Text(category.title)
			 .font(.title2)
		  HStack {
			 Image(systemName: "chevron.left")
			 
			 GeometryReader { geo in
				ScrollView {
				  VStack(spacing: 0) {
					 Text(category.title)
						.font(.title2.weight(.semibold))
						.padding(.bottom)
					 ForEach(Array(shelvesOfItems.enumerated()), id: \.offset) { index, items in
						let assetName = index == 0 ? "CategoriesTop2" : middleShelfAssets[(index - 1) % middleShelfAssets.count]
						
						
						shelfRow(items: items, assetName: assetName, first: index == 0)
					 }
					 
					 //  Always one empty "on the way" shelf at the very bottom.
					 shelfRow(items: [], assetName: "CategoriesMiddle3", isOnTheWay: true, first: false)
					 
				  }
				  .frame(minHeight: geo.size.height, alignment: .bottom)
				}
				.scrollBounceBehavior(.basedOnSize)
				.compositingGroup()
			 }
			 
			 Image(systemName: "chevron.right")
		  }
		}
		.ignoresSafeArea(edges: .bottom)
		.fontDesign(.serif)
	 }
  }

  @ViewBuilder
  private func shelfRow(items: [String?], assetName: String, isOnTheWay: Bool = false, first: Bool) -> some View {
	 ZStack {
		Image(assetName)
		  .resizable()
		  .aspectRatio(1920.0 / 1080.0, contentMode: .fit)
		  .opacity(0.8)

		if !isOnTheWay {
		  HStack(spacing: 45) {
			 ForEach(Array(items.enumerated()), id: \.offset) { index, title in
				if let title {
				  let second = index % 2 == 0
				  VStack{
					 Image("PhilosophyStore01Light")
						.resizable()
						.scaledToFit()
						.frame(maxWidth: .infinity)
						.scaleEffect(1.3)
						.scaleEffect(x: second ? 1 : -1)
						.shadow(radius: 1)
						.padding(.bottom, first ? 5 : 10)
				  }
				} else {
				  Color.clear
					 .frame(maxWidth: .infinity)
				}
			 }
		  }
		  .padding(.horizontal, 45)
		}
	 }
  }
}

#Preview {
  CategoryView(category: .culture)
	 .environment(ThemeManager())
}
