//
//  HighlightsGrid.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import SwiftUI

struct HighlightsGrid: View {
  @Environment(ThemeManager.self) var themeManager
  let highlights: [HighlightModel]
    var body: some View {
		VStack{
		  if highlights.isEmpty{
			 Image(themeManager.themeAssets.emptyState)
				.resizable()
				.scaledToFit()
				.padding(45)
			 Text("Nothing here")
				.title()
			 Text("Read and highlight the text\n to create some")
				.multilineTextAlignment(.center)
				.secondary()
		  }else{
			 ScrollView{
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
				  ForEach(highlights){item in
					 HighlightItem(item, backImage: themeManager.themeAssets.backSmallCard)
				  }
				}
			 }
		  }
		}
    }
}

#Preview {
  let array: [HighlightModel] = Array(0...4).map{_ in HighlightModel.previewf() }
  HighlightsGrid(highlights: [])
	 .environment(ThemeManager())
}


@ViewBuilder
func HighlightItem(_ highlight: HighlightModel, backImage: String) -> some View{
  VStack{
	 Spacer()
	 Text(highlight.text)
		.multilineTextAlignment(.center)
		.accent()
		.lineLimit(3)
	 
	 Spacer()
	 Text(ReadCategories(rawValue: highlight.categoryId)?.title ?? "")
		.secondary(weight: .light)
  }
  .padding()
  .padding(.horizontal)
  .padding(.vertical, 5)
  .background(
	 Image(backImage)
		.resizable()
  )
}
