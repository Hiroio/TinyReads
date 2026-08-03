//
//  WarningPopUp.swift
//  TinyReads
//
//  Created by user on 27.07.2026.
//

import SwiftUI

struct WarningPopUp: View {
  @Environment(ThemeManager.self) var themeManager
  let type: WarningPopUpEnum
  let confirmationAction: () -> ()
  var body: some View {
	 VStack{
		VStack{
		  Text(type.title)
			 .accent(weight: .semibold)
			 .padding(.vertical, 10)
		  Text(type.caption)
			 .secondary(weight: .light)
		}
		.padding()
		.multilineTextAlignment(.center)
		HStack(spacing: 25){
		  Button{
			 withAnimation(){
				NavigationManager.shared.dismissWarning()
			 }
		  }label:{
			 Text("Cancel")
				.regular(weight: .semibold)
		  }
		  .buttonStyle(CircleBtnStyle())
		  .foregroundStyle(themeManager.themeAssets.primary)


		  Button{
			 withAnimation{
				confirmationAction()
				NavigationManager.shared.dismissWarning()
			 }
		  }label:{
			 Text(type.confirmText)
				.accent(weight: .semibold)
		  }
		  .buttonStyle(CircleBtnStyle())
		  .foregroundStyle(themeManager.themeAssets.accent)
		}
		.padding(.bottom, 15)
	 }
	 .padding()
	 .padding(.horizontal) 
	 .background(
		Image(themeManager.themeAssets.backSmallCard)
		  .resizable()
	 )
  }
}

#Preview {
  WarningPopUp(type: .deleteHighlight){}
	 .environment(ThemeManager())
}

