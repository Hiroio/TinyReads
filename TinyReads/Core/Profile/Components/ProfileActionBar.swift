//
//  ProfileActionBar.swift
//  TinyReads
//
//  Created by user on 11.06.2026.
//

import SwiftUI

enum ProfileActionBarEnum: String, Identifiable, CaseIterable{
  case language, theme, categories, avatars
  
  var id: String {self.rawValue}
  
  var icon: String{
	 switch self {
	 case .language:
		"LanguageActionIcon"
	 case .theme:
		"ThemeActionIcon"
	 case .categories:
		"CategoriesActionIcon"
	 case .avatars:
		""
	 }
  }
}

struct ProfileActionBar: View {
  @Environment(ThemeManager.self) var themeManager
  @Binding var profileActionCard: ProfileActionBarEnum?
  let buttons: [ProfileActionBarEnum] = [.language, .theme, .categories]
    var body: some View {
		HStack{
		  ForEach(buttons){item in
			 Button{
				withAnimation{
				  profileActionCard = item
				}
			 }label:{
				let image = "\(item.icon)\(themeManager.appTheme == .dark ? "Dark" : "")"
				Image(image)
				  .resizable()
				  .scaledToFit()
				  .frame(width: 55)
				  .frame(maxWidth: .infinity)
			 }
			 .tinyAccessibilityButton(item.accessibilityLabel, hint: item.accessibilityHint)
		  }
		}
		.padding()
    }
}

#Preview {
  ProfileActionBar(profileActionCard: .constant(nil))
	 .environment(ThemeManager())
}
