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
		HStack(alignment: .bottom, spacing: 0){
		  ForEach(ArchiveState.allCases){item in
			 let state = vm.state == item
			 Button{
				vm.changeState(item)
				}label:{
				  Text(item.text)
					 .font( state ? .footnote.weight(.regular) : .caption)
					 .foregroundStyle(state ?  themeManager.themeAssets.accent : themeManager.themeAssets.secondary)
					 .padding(.vertical)
					 .padding(.horizontal, 10)
					 .padding(.bottom, state ? 15 : 0)
					 .background(
						Image(themeManager.themeAssets.topArticleCard)
						  .resizable()
						  .shadow(color: state ? themeManager.themeAssets.accent : .black.opacity(0.02), radius: 2, y: -1)
						  .clipShape(.rect)
					 )
				}
				.tinyAccessibilityButton(ArchiveState.read.accessibilityLabel)
				  
		  }
		  .fontDesign(.serif)
		  .animation(.easeInOut, value: vm.state)
		  }
    }
}

#Preview {
    ArchiveSwitch(vm: ArchiveViewModel())
	 .environment(ThemeManager())
}
