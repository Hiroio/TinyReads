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
		  themeManager.themeAssets.background.ignoresSafeArea()
		  
		  VStack(spacing: 5){
			 ArchiveSwitch(vm: vm)
			 
			 Spacer()
			 
			 if vm.filetredReads.isEmpty{
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
					 ForEach(vm.filetredReads){item in
						ArchiveCard(read: item, state: vm.state.cardStatus) {
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
		.overlay(alignment: .topLeading){
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
			 .padding()
		}
		.animation(.easeInOut, value: vm.selectedFilter)
		.animation(.easeInOut, value: vm.filetredReads.count)
		.task {
		  await vm.initialize()
		}
    }
}

#Preview {
  ArchiveView()
	 .environment(ThemeManager())
}
