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
					 .font(active ? .headline : .subheadline)
				  }
				  .strikethrough(!active, color: assets.secondary)
				  .foregroundStyle(active ? assets.accent : assets.secondary)
				}
			 }
		  }
		  .padding(.vertical)
		  
		  Button{
			 onDismiss()
		  }label:{
			 Text("Close")
				.secondary()
				.padding(.top)
		  }
		}
		.padding()
		.padding(.horizontal)
		.padding()
		.background(
		  Image(assets.backSmallCard)
			 .resizable()
		)
    }
}

#Preview {
  ProfileLanguageView(){}
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
