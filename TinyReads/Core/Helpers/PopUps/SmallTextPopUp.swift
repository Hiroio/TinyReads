//
//  SmallTextPopUp.swift
//  TinyReads
//
//  Created by user on 20.07.2026.
//

import SwiftUI

struct SmallTextPopUp: View {
  @Environment(ThemeManager.self) var themeManager
  let text: String
  let role: PopUpRole
  @Binding var isPresented: Bool
    var body: some View {
        Text(text)
		  .foregroundStyle(role.color(theme: themeManager.themeAssets))
		  .padding()
		  .background(
			 Image(themeManager.themeAssets.readerCard)
				.resizable()
		  )
		  .onAppear{
			 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
				isPresented = false
			 }
		  }
		  
    }
}

#Preview {
  SmallTextPopUp(text: "Text Copied!", role: .success, isPresented: .constant(false))
	 .environment(ThemeManager())
}

enum PopUpRole{
  case destructive, success, standart
  
  
  func color(theme: AppThemeAssets) -> Color{
	 switch self {
	 case .destructive:
		theme.destructive
	 case .standart:
		theme.primary
	 case .success:
		theme.accent
	 }
  }
}
