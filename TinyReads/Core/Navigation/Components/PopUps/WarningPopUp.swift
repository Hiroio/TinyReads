//
//  WarningPopUp.swift
//  TinyReads
//
//  Created by user on 27.07.2026.
//

import SwiftUI

struct WarningPopUp: View {
  @Environment(ThemeManager.self) var themeManager
  @Binding var caption: String
  let leaveAction: () -> ()
  var body: some View {
	 VStack{
		VStack{
		  Text("You have some unfinished business")
			 .accent(weight: .semibold)
			 .padding(.vertical, 10)
		  Text(caption)
			 .secondary(weight: .light)
		}
		.padding()
		.multilineTextAlignment(.center)
		HStack(spacing: 25){
		  Button{
			 withAnimation(){
				caption = ""
			 }
		  }label:{
			 Text("Cancel")
				.regular(weight: .semibold)
		  }
		  .buttonStyle(CircleBtnStyle())
		  .foregroundStyle(themeManager.themeAssets.primary)
		  
		  
		  Button{
			 withAnimation{
				leaveAction()
			 }
		  }label:{
			 Text("Leave")
				.accent(weight: .semibold)
		  }
		  .buttonStyle(CircleBtnStyle())
		  .foregroundStyle(themeManager.themeAssets.accent)
		}
		.padding(.bottom, 15)
	 }
	 .padding()
	 .background(
		Image(themeManager.themeAssets.backSmallCard)
		  .resizable()
	 )
  }
}

#Preview {
  WarningPopUp(caption: .constant("QWe qwheIUQ HWeiuhq IUEhuiq wuehqiuh, dwqjdijqw qwjdioiwq dwiqjdojwqd")){}
	 .environment(ThemeManager())
}

