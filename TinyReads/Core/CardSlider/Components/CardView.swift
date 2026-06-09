//
//  CardView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(NavigationManager.self) var navigationManager
  let displayCard: DisplayReadCard
  
  private var card: ReadCardModel {
	 displayCard.card
  }
  
  var body: some View {
	 VStack(spacing: 10){
		VStack(spacing: 15){
		  Text(card.categoryId)
			 .secondary()
		  Text(card.title)
			 .title()
		  Text(card.hook)
			 .secondary()
			 .padding(.horizontal, 10)
		}
		.multilineTextAlignment(.center)
		.padding(30)
		
		Button{
		  navigationManager.article = card
		}label:{
		  Text("Read")
			 .font(.largeTitle.weight(.light))
			 .fontDesign(.serif)
			 .foregroundStyle(themeManager.themeAssets.accent)
		}
		
		VStack{
		  Text("\(card.wordCount) words")
		  Text("Read time: \(card.estimatedMinutes) min.")
		}
		.font(.caption)
		.foregroundStyle(themeManager.themeAssets.secondary)
		.padding(.bottom)
		
		if displayCard.status != .fresh {
		  Text(displayCard.status.title)
			 .font(.caption.weight(.semibold))
			 .foregroundStyle(themeManager.themeAssets.accent)
			 .padding(.top, 4)
		}
	 }
	 .padding()
	 .frame(maxWidth: .infinity)
	 .background(
		Image(themeManager.themeAssets.backCard)
		  .resizable(resizingMode: .stretch)
	 )
  }
}

#Preview {
  CardView(displayCard: DisplayReadCard(card: ReadCardModel.getForPreview(), status: .fresh))
	 .environment(NavigationManager.shared)
	 .environment(ThemeManager())
}
