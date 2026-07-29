//
//  HighlightGridHeader.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import SwiftUI

struct HighlightGridHeader: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var vm: HighlightViewModel
  
    var body: some View {
		HStack{
		  Button{
			 NavigationManager.shared.secondary = nil
		  }label:{
			 Image(systemName: "xmark")
				.resizable()
				.scaledToFit()
				.padding(15)
		  }
		  .buttonStyle(SmallBtnStyle())
		  
		  Spacer()
		  
		  Button{
			 withAnimation {
				vm.widgetState.toggle()
			 }
		  }label:{
			 Image(themeManager.themeAssets.widgetAction)
				.resizable()
				.scaledToFit()
				.shadow(color: vm.widgetState ? themeManager.themeAssets.accent : .clear, radius: 1)
				.shadow(color: vm.widgetState ? themeManager.themeAssets.accent : .clear ,radius: 2)
		  }
		  .buttonStyle(SmallBtnStyle())
		  .disabled(vm.highlights.isEmpty || vm.deleteState)
		  
		  Button{
			 withAnimation {
				vm.deleteState.toggle()
			 }
		  }label:{
			 Image(themeManager.themeAssets.deleteAction)
				.resizable()
				.scaledToFit()
				.shadow(color: vm.deleteState ? themeManager.themeAssets.accent :  themeManager.themeAssets.primary ,radius: 1)
				.shadow(color: vm.deleteState ? themeManager.themeAssets.accent : .clear ,radius: 1)
		  }
		  .disabled(vm.highlights.isEmpty || vm.widgetState)
		  .buttonStyle(SmallBtnStyle())
		}
		.padding(.horizontal)
		.frame(height: 55)
    }
}

#Preview {
  HighlightGridHeader(vm: HighlightViewModel())
	 .environment(ThemeManager())
}
