//
//  HighlightsGrid.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import SwiftUI

struct HighlightsGrid: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var vm: HighlightViewModel
	var body: some View {
		VStack{
		  if vm.highlights.isEmpty{
			 VStack{
				Image(themeManager.themeAssets.emptyState)
				  .resizable()
				  .scaledToFit()
				  .padding(45)
				Text("Nothing here")
				  .title()
				Text("Read and highlight the text\n to create some")
				  .multilineTextAlignment(.center)
				  .secondary()
			 }
			 .frame(maxHeight: .infinity)
			 .padding(40)
			 .background(
				PaperBackGround()
				  .ignoresSafeArea()
			 )
		  }else{
			 ScrollView{
				CustomSearchBar(searchText: $vm.searchText)
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
				  ForEach(vm.highlights){item in

					 Button{
						if vm.deleteState{
						  NavigationManager.shared.showWarning(.deleteHighlight) {
							 vm.deleteHighlight(highlight: item)
						  }
						}else{
						  NavigationManager.shared.highlight = .idle(item)
						}
					 }label:{
						HighlightItem(item, backImage: vm.deleteState ? themeManager.themeAssets.deleteBackSmallCard : themeManager.themeAssets.backSmallCard)
					 }
				  }
				}
				.frame(maxHeight: .infinity)
				.padding(40)
				.background(
				  PaperBackGround()
					 .ignoresSafeArea()
				)
			 }

		  }
		}
	}
}

#Preview {
  HighlightsGrid(vm: HighlightViewModel())
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
