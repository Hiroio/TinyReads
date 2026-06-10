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
		Button{
		  withAnimation(){
			 NavigationManager.shared.secondary = nil
		  }
		}label:{
		  Image(systemName: "chevron.left")
			 .foregroundStyle(themeManager.themeAssets.secondary)
			 .padding()
		},
		alignment: .topLeading
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
