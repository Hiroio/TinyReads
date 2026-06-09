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
			 
			 ScrollView{
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
				  ForEach(vm.reads){item in
					 ArchiveCard(read: item)
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
				.foregroundStyle(themeManager.themeAssets.primary)
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
    ArchiveView()
	 .environment(ThemeManager())
}
