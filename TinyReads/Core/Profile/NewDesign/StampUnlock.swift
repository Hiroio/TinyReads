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
  let categories: [ReadCategories]

	 var body: some View {
		VStack(spacing: 25){
		  VStack{
			 Text("Congratulations!")
				.font(.title.weight(.bold))
				.foregroundStyle(themeManager.themeAssets.accent)

			 subTitle
		  }

		  ZStack{
			 ForEach(categories.indices, id: \.self){ index in
				Image(categories[index].stamp + (themeManager.colorScheme == .dark ? "Dark" : "Light"))
				  .resizable()
				  .scaledToFit()
				  .compositingGroup()
				  .shadow(radius: 10)
				  .scaleEffect(animation ? 1 : 0.5)
				  //  angle comes from the index, not from random(), so the pile
				  //  does not twitch on every redraw
				  .rotationEffect(.degrees(Double(index) * 1.5))
			 }
		  }

		  footnote

		  Button{
			 withAnimation{
				animation = false
				NavigationManager.shared.stampPopUp = []
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
  StampUnlock(categories: [.culture])
	 .environment(ThemeManager())
}


extension StampUnlock{
  //  `Text` rather than a computed String: Text(String) uses the verbatim initializer and never
  //  looks the key up in the catalog, so a String here would silently drop every translation.
  //  The plural forms for "%lld new stamps" live in the catalog too.
  @ViewBuilder
  private var subTitle: some View{
	 if categories.count > 1{
		Text("You unlocked \(categories.count) new stamps")
	 }else if let category = categories.first{
		Text("You unlocked the \(category.title) stamp")
	 }
  }

  @ViewBuilder
  private var footnote: some View{
	 if categories.count > 1{
		Text("Each stamp takes 80 articles in its category")
	 }else{
		Text("You have been through 80 articles in this category")
	 }
  }
}
