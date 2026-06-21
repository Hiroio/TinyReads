//
//  ArchiveSwitch.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import SwiftUI

struct ArchiveSwitch: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var vm: ArchiveViewModel
//  MARK: For preview
    var body: some View {
		HStack(spacing: 15){
		  let state = vm.state == .read
			 Button{
				vm.changeState(to: .saved)
			 }label:{
				Text(ArchiveState.saved.text)
				  .font( state ? .footnote : .headline.weight(.regular))
				  .foregroundStyle(state ? themeManager.themeAssets.secondary : themeManager.themeAssets.accent)
			 }
			 .tinyAccessibilityButton(ArchiveState.saved.accessibilityLabel)
		  
		  Rectangle()
			 .frame(width: 0.5, height: 25)
			 .rotationEffect(Angle(degrees: 10))
		  
		  Button{
			 vm.changeState(to: .read)
			 }label:{
				Text(ArchiveState.read.text)
				  .font( state ? .headline.weight(.regular) : .footnote)
				  .foregroundStyle(state ? themeManager.themeAssets.accent : themeManager.themeAssets.secondary)
			 }
			 .tinyAccessibilityButton(ArchiveState.read.accessibilityLabel)
				
		}
		.fontDesign(.serif)
		.animation(.easeInOut, value: vm.state)
		.padding()
    }
}

#Preview {
    ArchiveSwitch(vm: ArchiveViewModel())
	 .environment(ThemeManager())
}
