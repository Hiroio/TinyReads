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
				if vm.categoriesFilter{
				  ArchiveCategoryFilter(vm: vm)
					 .transition(.opacity)
				}else{
				  HStack{
					 CustomSearchBar(searchText: $vm.searchText)
					 filterButton
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
		.sheet(isPresented: $vm.subCategoriesFilter){
		  ArchiveSubCategoryFilter(vm: vm)
			 .padding()
			 .presentationDetents([.medium])
			 .presentationCornerRadius(0)
			 .presentationBackground {
				PaperBackGround()
				  .ignoresSafeArea()
				  .scaleEffect(1.1)
			 }
		}
		.overlay(alignment: .topLeading){
		  activeHeader
		}
		.animation(.easeInOut, value: vm.selectedSubCategoryIds)
		.animation(.easeInOut, value: vm.selectedCategories)
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


extension ArchiveView{
  private var filterButton: some View{
	 Button{
		withAnimation{
		  vm.subCategoriesFilter = true
		}
	 }label:{
		HStack(spacing: 4){
		  Image(systemName: "line.3.horizontal.decrease")
		  filterTitle
		}
		.accent()
	 }
  }

  //  Shows the state, so it is clear the archive is filtered even with the sheet closed.
  @ViewBuilder
  private var filterTitle: some View{
	 if vm.selectedSubCategories.count == 1, let only = vm.selectedSubCategories.first{
		Text(only.title)
	 }else if vm.selectedSubCategoryIds.isEmpty{
		Text("All")
	 }else{
		Text("\(vm.selectedSubCategoryIds.count) selected")
	 }
  }
  
  
  
  @ViewBuilder
  private var activeHeader: some View{
	 HStack{
		Button{
		  withAnimation(){
			 NavigationManager.shared.secondary = nil
		  }
		}label:{
		  Image(systemName: "xmark")
			 .foregroundStyle(themeManager.themeAssets.accent)
			 .padding(5)
		}
		.buttonStyle(SmallBtnStyle())
		
		Spacer()
		
		Button{
		  withAnimation {
			 vm.categoriesFilter.toggle()
		  }
		}label: {
		  if vm.categoriesFilter{
			 Image(systemName: "checkmark")
				.foregroundStyle(themeManager.themeAssets.accent)
				.padding(5)
		  }else{
			 Image(themeManager.themeAssets.navigationCategories)
				.resizable()
				.scaledToFit()
				.overlay(alignment: .topTrailing){
				  //  no badge when nothing is picked — that already means "every category"
				  if !vm.selectedCategories.isEmpty{
					 Text("\(vm.selectedCategories.count)")
						.font(.caption2.weight(.bold))
						.foregroundStyle(.white)
						.padding(4)
						.background(
						  Circle()
							 .fill(themeManager.themeAssets.accent)
						)
						.offset(x: 6, y: -6)
				  }
				}
		  }
		}
		.buttonStyle(SmallBtnStyle())
		
	 }
	 .frame(height: 45)
	 .padding(8)
  }
}
