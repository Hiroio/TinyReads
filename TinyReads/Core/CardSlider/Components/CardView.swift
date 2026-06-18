//
//  CardView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardView: View {
  @Environment(ThemeManager.self) var themeManager
  let displayCard: DisplayReadCard
  let showsTapHint: Bool
  
  init(displayCard: DisplayReadCard, showsTapHint: Bool = true) {
	 self.displayCard = displayCard
	 self.showsTapHint = showsTapHint
  }
  
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
				.allowsTightening(false)
			 Text(card.hook)
				.secondary()
				.padding(.horizontal, 10)
				.allowsTightening(true)
		  }
		  .multilineTextAlignment(.center)
		  .frame(maxWidth: .infinity)
		  .padding(30)
		  
		  VStack{
			 Text("\(card.wordCount) words")
			 Text("Read time: \(card.estimatedMinutes) min.")
		  }
		  .font(.caption)
		  .foregroundStyle(themeManager.themeAssets.secondary)
		  .padding(.bottom)
		  
		  if showsTapHint {
			 Text("*Tap to read*")
				.font(.caption)
				.fontDesign(.serif)
				.foregroundStyle(themeManager.themeAssets.accent)
				.allowsHitTesting(false)
		  }
		  
		  if displayCard.status != .fresh {
			 Text(displayCard.status.title)
				.font(.caption.weight(.semibold))
				.foregroundStyle(themeManager.themeAssets.accent)
				.padding(.top, 4)
		  }
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(0.7, contentMode: .fit)
		.background(
		  Image(themeManager.themeAssets.backCard)
			 .resizable(resizingMode: .stretch)
		)
		.compositingGroup()
		.shadow(radius: 5)
  }
}

#Preview {
  CardView(displayCard: DisplayReadCard(card: ReadCardModel.getForPreview(), status: .fresh))
	 .environment(NavigationManager.shared)
	 .environment(ThemeManager())
}
