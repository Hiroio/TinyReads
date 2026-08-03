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
//		  Search for Higlight
		  CustomSearchBar(searchText: $vm.searchText)
			 .padding(.horizontal, UIDevice.isIPad ? 20 : 10)
			 .disabled(vm.highlights.isEmpty)

//		  Filter categories
		  ScrollView(.horizontal){
			 LazyHStack{
				ForEach(vm.availableHighlightsCategories, id: \.id){item in
				  let selected = vm.unSelectedFilterCategories.contains(item)
				  Button{
					 vm.handleFilterCategory(category: item)
				  }label:{
					 Text(item.title)
						.font(.footnote.weight(.light))
						.foregroundStyle(selected ? themeManager.themeAssets.secondary : themeManager.themeAssets.accent)
						.underline(!selected)
						.fontDesign(.serif)
						.padding(5)
						.shadow(color: themeManager.themeAssets.accent.opacity(0.5),radius: 5)
				  }
				}
			 }
		  }
		  .fixedSize(horizontal: false, vertical: true)
		  .padding(.horizontal, UIDevice.isIPad ? 35 : 20)
		  
//		  Grid
		  if vm.searchResult.isEmpty{
			 VStack{
				Image(themeManager.themeAssets.emptyState)
				  .resizable()
				  .scaledToFit()
				  .padding(45)
				Text(vm.highlights.isEmpty ? "Nothing here" : "No matches")
				  .title()
				Text(vm.highlights.isEmpty ? "Read and highlight the text\n to create some" : "Try adjusting your search or filters")
				  .multilineTextAlignment(.center)
				  .secondary()
			 }
			 .frame(maxHeight: .infinity)
		  }else{
			 ScrollView{
				LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 2)) {
				  ForEach(vm.searchResult){item in

					 Button{
						if vm.deleteState{
						  NavigationManager.shared.showWarning(.deleteHighlight) {
							 vm.deleteHighlight(highlight: item)
						  }
						}else if vm.widgetState{
						  vm.activateForWidget(highlight: item)
						  }else{
						  NavigationManager.shared.highlight = .idle(item)
						}
					 }label:{
						HighlightItem(item, backImage: vm.deleteState ? themeManager.themeAssets.deleteBackSmallCard : themeManager.themeAssets.backSmallCard)
						  .overlay(alignment: .topLeading){
							 ZStack{
								if item.widgetIsActive{
								  Image(themeManager.themeAssets.widgetAction)
									 .resizable()
									 .scaledToFit()
									 .frame(height: UIDevice.isIPad ? 65 : 40 )
								}
							 }
						  }
						  .scaleEffect(item.widgetIsActive ? 0.95 : 1)
						  .scaleEffect(vm.widgetState ? 1.05 : 1)
						  .shadow(color: .yellow, radius: item.widgetIsActive ? 2 : 0)
					 }
					 .buttonStyle(.plain)
				  }
				}
				.padding(.horizontal, 15)
				.frame(maxHeight: .infinity)
			 }
		  }
			 
		}
		.padding(UIDevice.isIPad ? 50 : 20)
		.background(
		  PaperBackGround()
			 .ignoresSafeArea()
		)
		.animation(.easeInOut, value: vm.searchResult)
		.animation(.easeInOut, value: vm.unSelectedFilterCategories)
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
		.font(UIDevice.isIPad ? .title3 : .footnote)
		.multilineTextAlignment(.center)
		.accent()
		.lineLimit(3)

	 Spacer()
	 Text(ReadCategories(rawValue: highlight.categoryId)?.title ?? "")
		.font(UIDevice.isIPad ? .headline : .footnote)
		.secondary(weight: .light)
  }
  .padding(UIDevice.isIPad ? 45 : 25)
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .aspectRatio(UIDevice.isIPad ? 1.1 : 1, contentMode: .fit)
  .background(
	 Image(backImage)
		.resizable()
  )
  .drawingGroup()
}
