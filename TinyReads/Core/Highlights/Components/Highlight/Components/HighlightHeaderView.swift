//
//  HighlightHeaderView.swift
//  TinyReads
//
//  Created by user on 27.07.2026.
//

import SwiftUI

struct HighlightHeaderView: View {
  @Environment(ThemeManager.self) var themeManager
  @Binding var noteIsActive: Bool
  
  let exitAction: () -> ()
    var body: some View {
		HStack{
		  if noteIsActive{
			 Button{
				withAnimation{
				  noteIsActive = false
				}
			 }label:{
				Image(systemName: "arrow.left")
				  .foregroundStyle(themeManager.themeAssets.accent)
				  .padding(10)
				  .background(
					 Image(themeManager.themeAssets.backSmallCard)
						.resizable()
				  )
			 }
		  }
		  
		  Spacer()
		  
		  Button{
			 exitAction()
		  }label:{
			 Image(systemName: "xmark")
				.foregroundStyle(themeManager.themeAssets.accent)
				.padding(10)
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
				)
		  }
		}
		  .frame(maxWidth: .infinity)
    }
}

#Preview {
  HighlightHeaderView(noteIsActive: .constant(false)){}
	 .environment(ThemeManager())
}
