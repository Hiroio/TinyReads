//
//  ArchiveView.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import SwiftUI

struct ArchiveView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = ArchiveViewModel()
    var body: some View {
		ZStack{
		  VStack(spacing: 0){
			 ArchiveSwitch(vm: vm)
			 
			 VStack{
				HStack{
				  CustomSearchBar(searchText: $vm.searchText)
				  CategoryFilterView(selectedFilter: $vm.selectedCategory)
					 .padding(.trailing)
				}
				Spacer()
				
				if vm.filteredResults.isEmpty{
				  VStack{
					 Image(themeManager.themeAssets.emptyState)
						.resizable()
						.scaledToFit()
					 Text("Can't find nothing")
						.title()
						.padding()
				  }
				  .aspectRatio(1.5, contentMode: .fit)
				}else{
				  ScrollView{
					 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: UIDevice.isIPad ? 3 : 2)) {
						ForEach(vm.filteredResults){item in
						  ArchiveCard(read: item.card, state: item.status) {
							 vm.onInteractionChange(item.id)
						  }
						  .environment(vm)
						}
					 }
					 .padding(5)
				  }
				}
			 }
			 .background(
				themeManager.themeAssets.card.ignoresSafeArea()
			 )
			 .clipShape(
				UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, topTrailing: 15))
			 )
			 .ignoresSafeArea(edges: .bottom)
		  }
		}
		.overlay(alignment: .topLeading){
		  HStack{
			 Button{
				withAnimation(){
				  NavigationManager.shared.secondary = nil
				}
			 }label:{
				Image(systemName: "xmark")
				  .foregroundStyle(themeManager.themeAssets.accent)
			 }
			 
			 Spacer()
			 
		  }
			 .padding()
		}
		.animation(.easeInOut, value: vm.selectedCategory)
		.animation(.easeInOut, value: vm.filteredResults.count)
		.task {
		  await vm.initialize()
		}
    }
}

#Preview {
  ArchiveView()
	 .environment(ThemeManager())
}
