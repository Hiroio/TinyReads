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
		HStack{
		  Image(themeManager.themeAssets.freshSwipeMode)
			 .resizable()
			 .scaledToFit()
			 .frame(height: 55)
		  
		  Text(role.title)
			 .accent(weight: .medium)
			 .fixedSize()
			 .frame(maxWidth: .infinity)
		  
		  
		  Image(themeManager.themeAssets.repeatSwipeMode)
			 .resizable()
			 .scaledToFit()
			 .frame(height: 55)
		}
		  .frame(maxWidth: .infinity)
		  .padding()
		  .background(
			 Image(themeManager.themeAssets.readerCard)
				.resizable()
				.shadow(radius: 2)
		  )
		  .onTapGesture(perform: {
			 withAnimation {
				NavigationManager.shared.popUpState = nil
			 }
		  })
		  .padding(.horizontal, 30)
		  .onAppear{
			 DispatchQueue.main.asyncAfter(deadline: .now() + 2){
				NavigationManager.shared.popUpState = nil
			 }
		  }
		  
    }
}

#Preview {
  SmallTextPopUp(role: .copied)
	 .environment(ThemeManager())
}
