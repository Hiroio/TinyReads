//
//  StampUnlock.swift
//  TinyReads
//
//  Created by user on 17.09.2026.
//

import SwiftUI

struct StampUnlock: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var animation: Bool = false
  let category: ReadCategories
    var body: some View {
		VStack(spacing: 25){
		  VStack{
			 Text("Congratulations!")
				.font(.title.weight(.bold))
				.foregroundStyle(themeManager.themeAssets.accent)
			 Text("You unlocked the \(category.title) stamp")
		  }
		  
		  Image(category.stamp + "Light")
			 .resizable()
			 .scaledToFit()
			 .compositingGroup()
			 .shadow(radius: 10)
			 .scaleEffect(animation ? 1 : 0.5)
		  
		  Text("You have been through 80 articles in this category")
		  
		  Button{
			 withAnimation{
				animation = false
				NavigationManager.shared.stampPopUp = nil
			 }
		  }label:{
			 Text("Continue")
				.padding()
				.foregroundStyle(.white)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(themeManager.themeAssets.accent)
				)
		  }
		}
		.padding(45)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1/1.5, contentMode: .fit)
		.background(
		  PaperBackGround()
		)
		.multilineTextAlignment(.center)
		.fontDesign(.serif)
		.onAppear{
		  withAnimation(.easeInOut(duration: 0.6)){
			 animation = true
		  }
		}
    }
}

#Preview {
  StampUnlock(category: .culture)
	 .environment(ThemeManager())
}
