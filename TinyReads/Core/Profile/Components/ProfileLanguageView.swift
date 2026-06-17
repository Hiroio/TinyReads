//
//  ProfileLanguageView.swift
//  TinyReads
//
//  Created by user on 17.06.2026.
//

import SwiftUI

struct ProfileLanguageView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefault
  let onDismiss: () -> ()
    var body: some View {
		let assets = themeManager.themeAssets
		VStack{
		  Text("Language")
			 .title()
		  
		  ForEach(LanguageEnum.allCases){item in
			 let active = userDefault.selectedLanguage == item
			 Button{
				userDefault.selectedLanguage = item
			 }label:{
				Text(item.rawValue)
				  .padding()
				  .font(.title3.weight(.light))
				  .fontDesign(.serif)
				  .strikethrough(!active, color: assets.secondary)
				  .foregroundStyle(active ? assets.accent : assets.secondary)
			 }
		  }
		}
		.overlay(
		  Button{
			 onDismiss()
		  }label:{
			 Image(systemName: "xmark")
				.font(.headline)
				.foregroundStyle(assets.primary)
		  }
		)
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(.horizontal, 50)
		.aspectRatio(1.2, contentMode: .fit)
		.background(
		  Image(assets.backCard)
			 .resizable()
		)
    }
}

#Preview {
  ProfileLanguageView(){}
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
