//
//  ProfileLanguageView.swift
//  TinyReads
//
//  Created by user on 17.06.2026.
//

import SwiftUI

struct ProfileLanguageView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefault
    var body: some View {
		let assets = themeManager.themeAssets
		VStack{
		  Text("Language")
			 .title()
		  
		  VStack(alignment: .leading, spacing: 8){
			 ForEach(LanguageEnum.allCases){item in
				let active = userDefault.selectedLanguage == item
				Button{
				  userDefault.selectedLanguage = item
				}label:{
				  HStack{
					 Circle()
						.frame(width: 5)
					 Text(item.title)
					 .font(active ? .title2 : .subheadline)
				  }
				  .strikethrough(!active, color: assets.secondary)
				  .foregroundStyle(active ? assets.accent : assets.secondary)
				}
				.tinyAccessibilityButton(item.title)
			 }
		  }
		  .padding(.vertical)
		}
    }
}

#Preview {
  ProfileLanguageView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
