//
//  CategoryDesign2.swift
//  TinyReads
//
//  Created by user on 06.09.2026.
//

import SwiftUI

struct CategoryDesign2: View {
  @Environment(ThemeManager.self) var themeManager
  let category: ReadCategories

  //  Groups subCategories 2-per-shelf; last shelf may have only 1 item.
  private var shelvesOfItems: [[any ReadSubCategory]] {
	 var result: [[any ReadSubCategory]] = []
	 var remaining = category.subCategories[...]
	 while !remaining.isEmpty {
		result.append(Array(remaining.prefix(2)))
		remaining = remaining.dropFirst(min(2, remaining.count))
	 }
	 return result
  }

  var body: some View {
	 GeometryReader { geo in
		let shelfHeight = geo.size.width * 0.45

		VStack(spacing: 0) {
		  Text(category.title)
			 .font(.title2.weight(.semibold))
			 .frame(maxWidth: .infinity, maxHeight: .infinity)

		  ScrollView(showsIndicators: false) {
			 VStack(spacing: 0) {
				ForEach(Array(shelvesOfItems.enumerated()), id: \.offset) { index, items in
				  shelfRow(items: items, height: shelfHeight, first: index == 0)
				}

				
				onTheWayRow(height: shelfHeight)
			 }
			 .padding(.top)
			 .background(
				Image(themeManager.themeAssets.readerCard)
				  .resizable()
				  .scaleEffect(x: 1.2)
			 )
		  }
		  .frame(height: shelfHeight * 3)
		}
		.frame(width: geo.size.width, height: geo.size.height)
	 }
	 .ignoresSafeArea(edges: .bottom)
	 .fontDesign(.serif)
  }

  @ViewBuilder
  private func shelfRow(items: [any ReadSubCategory], height: CGFloat, first: Bool) -> some View {
	 ZStack {
		

		VStack{
		  if first{
			 Rectangle()
				.stroke(lineWidth: 3)
				.frame(height: 1)
		  }
		  
		  HStack(spacing: 45) {
			 ForEach(Array(items.enumerated()), id: \.offset) { index, subCategory in
				bookView(subCategory, mirrored: index % 2 == 0)
			 }
		  }
		  .padding(.horizontal, 45)
		  
		  Rectangle()
			 .stroke(lineWidth: 3)
			 .frame(height: 1)
		}
	 }
	 .frame(height: height)
  }

  @ViewBuilder
  private func bookView(_ subCategory: any ReadSubCategory, mirrored: Bool) -> some View {
	 VStack(spacing: 4) {
		Image(subCategory.image)
		  .resizable()
		  .scaledToFit()
		  .rotationEffect(.degrees(mirrored ? -15 : 15))
		  .shadow(radius: 1)

		Text(subCategory.title)
		  .font(.footnote.weight(.semibold))
	 }
	 .frame(maxWidth: .infinity)
	 .overlay(alignment: .topTrailing) {
		if subCategory.storeId != nil {
		  Text("1.99$")
			 .font(.caption.weight(.black))
			 .foregroundStyle(.white)
			 .padding(10)
			 .background(
				RoundedRectangle(cornerRadius: 10).fill(themeManager.themeAssets.accent)
			 )
		}
	 }
  }

  @ViewBuilder
  private func onTheWayRow(height: CGFloat) -> some View {
	 ZStack {

		Text("On the way")
		  .font(.subheadline.weight(.black))
		  .foregroundStyle(themeManager.themeAssets.accent)
	 }
	 .frame(height: height)
  }
}

#Preview {
  CategoryDesign2(category: .culture)
	 .environment(ThemeManager())
}
