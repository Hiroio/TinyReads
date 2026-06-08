//
//  ThemeSelectorView.swift
//  TinyReads
//
//  Created by user on 08.06.2026.
//

import SwiftUI

struct ThemeSelectorView: View {
  @Environment(ThemeManager.self) var themeManager
    var body: some View {
		HStack(spacing: 0){
		  ForEach(AppTheme.allCases, id: \.self){ item in
			 let active = item == themeManager.appTheme
			 let icon = active ? item.activeIcon : item.icon
			 Button{
				withAnimation(.easeInOut){
				  themeManager.appTheme = item
				}
			 }label: {
				Image(systemName: icon)
				  .font(.headline)
				  .foregroundStyle(themeManager.themeAssets.primary)
				  .padding()
				  .background(
					 Rectangle()
						.fill(active ? themeManager.themeAssets.border : .clear)
				  )
			 }
		  }
		}
		.cornerRadius(10)
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(themeManager.themeAssets.border ,lineWidth: 1)
		)
    }
}

#Preview {
    ThemeSelectorView()
	 .environment(ThemeManager())
}
