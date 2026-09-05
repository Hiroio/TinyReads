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

  // MARK: Mock data — temporary, until real subCategory content exists for this shelf.
  private let mockItems = ["Universal", "Item 2", "Item 3"]

  //  Real-content shelf variants, cycled through for visual variety.
  private let middleShelfAssets = ["CategoriesMiddle1", "CategoriesMiddle2", "CategoriesMiddle4", "CategoriesMiddle5"]

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
	 VStack {
		Text(category.title)
		  .font(.title2)

		HStack {
		  Image(systemName: "chevron.left")

		  GeometryReader { geo in
			 ScrollView {
				VStack(spacing: 0) {
				  Image("CategoriesTop")
					 .resizable()
					 .aspectRatio(1920.0 / 1080.0, contentMode: .fit)

				  ForEach(Array(shelvesOfItems.enumerated()), id: \.offset) { index, items in
					 shelfRow(items: items, assetName: middleShelfAssets[index % middleShelfAssets.count])
				  }

				  //  Always one empty "on the way" shelf at the very bottom.
				  shelfRow(items: [], assetName: "CategoriesMiddle3", isOnTheWay: true)
				}
				.frame(minHeight: geo.size.height, alignment: .bottom)
			 }
			 .compositingGroup()
			 .shadow(radius: 5)
		  }

		  Image(systemName: "chevron.right")
		}
	 }
	 .fontDesign(.serif)
  }

  @ViewBuilder
  private func shelfRow(items: [String?], assetName: String, isOnTheWay: Bool = false) -> some View {
	 ZStack {
		Image(assetName)
		  .resizable()
		  .aspectRatio(1920.0 / 1080.0, contentMode: .fit)

		if !isOnTheWay {
		  HStack(spacing: 20) {
			 ForEach(Array(items.enumerated()), id: \.offset) { _, title in
				if let title {
				  Text(title)
					 .frame(maxWidth: .infinity)
				} else {
				  Color.clear
					 .frame(maxWidth: .infinity)
				}
			 }
		  }
		  .padding(.horizontal, 60)
		}
	 }
  }
}

#Preview {
  CategoryView(category: .culture)
	 .environment(ThemeManager())
}
