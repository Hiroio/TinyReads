//
//  DismissedView.swift
//  TinyReads
//
//  Created by user on 10.06.2026.
//

import SwiftUI

struct DismissedView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = DismissedViewModel()
  var body: some View {
	 ZStack{
		themeManager.themeAssets.background.ignoresSafeArea()
		
		VStack(spacing: 5){
		  Text("Dismissed")
			 .title()
			 .padding()
		  ScrollView{
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
				ForEach(vm.reads){item in
				  ArchiveCard(read: item, state: .dismissed){
					 vm.onInteractionChange(item.id)
				  }
				  .environment(vm)
				}
			 }
		  }
		}
	 }
	 .overlay(
		HStack{
		  Button{
			 withAnimation(){
				NavigationManager.shared.secondary = nil
			 }
		  }label:{
			 Image(systemName: "chevron.left")
				.foregroundStyle(themeManager.themeAssets.secondary)
				.frame(maxWidth: .infinity, alignment: .leading)
				
		  }
		  
		  
		  
		  Button{
			 withAnimation(.easeInOut){
				vm.filterSelection.toggle()
			 }
		  }label:{
			 Text(vm.selectedFilter)
				.accent()
				.frame(maxWidth: .infinity, alignment: .trailing)
		  }
			 .overlay(alignment: .topTrailing){
				VStack(alignment: .leading){
						ForEach(vm.filters, id: \.self){ item in
						  Button{
							 withAnimation{
								vm.selectedFilter = item
								vm.filterSelection = false
							 }
						  }label: {
							 Text(item)
								.font(.caption)
								.fontDesign(.serif)
								.foregroundStyle(vm.selectedFilter == item ? themeManager.themeAssets.accent : themeManager.themeAssets.secondary)
								.padding(5)
						  }
						}
					 }
					 .padding()
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(themeManager.themeAssets.card.opacity(0.8))
					 )
					 .offset(y: 20)
					 .opacity(vm.filterSelection ? 1 : 0)
				  }
		}
		  .padding(),
		alignment: .top
	 )
	 .task {
		await vm.initialize()
	 }
  }
}


#Preview {
  DismissedView()
	 .environment(ThemeManager())
}
