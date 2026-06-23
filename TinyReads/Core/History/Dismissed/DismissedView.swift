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
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: UIDevice.isIPad ? 3 : 2)) {
				ForEach(vm.filetredReads){item in
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
		  }
		  
		  Spacer()
		  
		  
		  CategoryFilterView(selectedFilter: $vm.selectedFilter)
		}
		  .padding(),
		alignment: .top
	 )
	 .animation(.easeInOut, value: vm.selectedFilter)
	 .animation(.easeInOut, value: vm.filetredReads.count)
	 .task {
		await vm.initialize()
	 }
  }
}


#Preview {
  DismissedView()
	 .environment(ThemeManager())
}
