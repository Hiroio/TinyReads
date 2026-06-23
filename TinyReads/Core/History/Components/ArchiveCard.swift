//
//  ArchiveCard.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import SwiftUI

struct ArchiveCard: View {
  @Environment(ThemeManager.self) var themeManager
  let read: ReadCardModel
  let state: ReadCardDisplayStatus
  let onInteractionChange: () -> ()
  var body: some View {
	 Button{
		let article = ArticleRoute(
		  article: read,
		  onInteractionChanged: onInteractionChange,
		  isAbleToInteract: state
		)
		NavigationManager.shared.article = article
	 }label: {
		VStack{
		  Text(read.title)
			 .secondary(weight: .bold)
			 .multilineTextAlignment(.center)
		  Text(read.categoryId)
			 .secondary(weight: .light)
		}
		.padding(.horizontal, 30)
		.padding(.trailing)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1, contentMode: .fit)
		.background(
		  Image("\(state.backCard)\(themeManager.themeAssets == .dark ? "Dark" : "")")
			 .resizable()
			 .scaledToFit()
		  
		)
		.compositingGroup()
		.shadow(radius: 3)
		.allowsTightening(true)
		
	 }
  }
}

#Preview {
  ArchiveCard(read: .getForPreview(), state: .archived) {}
	 .environment(ThemeManager())
}
