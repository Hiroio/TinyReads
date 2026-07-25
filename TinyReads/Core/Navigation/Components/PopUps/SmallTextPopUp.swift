//
//  SmallTextPopUp.swift
//  TinyReads
//
//  Created by user on 20.07.2026.
//

import SwiftUI

struct SmallTextPopUp: View {
  @Environment(ThemeManager.self) var themeManager
  let role: SmallPopUpEnum
    var body: some View {
		Text(role.title)
		  .foregroundStyle(themeManager.themeAssets.accent)
		  .frame(maxWidth: .infinity)
		  .padding()
		  .background(
			 Image(themeManager.themeAssets.readerCard)
				.resizable()
				.shadow(radius: 2)
		  )
		  .padding(.horizontal, 40)
		  .onAppear{
			 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
				NavigationManager.shared.popUpState = nil
			 }
		  }
		  
    }
}

#Preview {
  SmallTextPopUp(role: .copied)
	 .environment(ThemeManager())
}
