//
//  ThemeSelectorView.swift
//  TinyReads
//
//  Created by user on 08.06.2026.
//

import SwiftUI

struct ThemeSelectorView: View {
  @Environment(ThemeManager.self) var themeManager
  let onDismiss: () -> ()
  var body: some View {
	 VStack{
		Text("Theme selection")
		  .title()
		  .padding()
		
		
		HStack(spacing: 0){
		  ForEach(AppTheme.allCases, id: \.self){ item in
			 let active = item == themeManager.appTheme
			 let icon = active ? item.activeIcon : item.icon
			 Button{
				withAnimation(.easeInOut){
				  themeManager.appTheme = item
				  themeManager.changeColorTheme()
				}
			 }label: {
				Image(systemName: icon)
				  .font(.title)
				  .foregroundStyle(themeManager.themeAssets.primary)
				  .padding()
				  .background(
					 Rectangle()
						.fill(active ? themeManager.themeAssets.border : .clear)
				  )
			 }
			 .tinyAccessibilityButton("Change theme")
		  }
		}
		.cornerRadius(10)
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(themeManager.themeAssets.border ,lineWidth: 1)
		)
		
		Button{
		  onDismiss()
		}label:{
		  Text("Close")
			 .secondary()
			 .padding()
		}
		.tinyAccessibilityButton("Close")
	 }
	 .padding(50)
	 .background(
		Image(themeManager.themeAssets.backSmallCard)
		  .resizable()
		  .scaledToFit()
	 )
  }
}

#Preview {
  ThemeSelectorView(){}
	 .environment(ThemeManager())
}
