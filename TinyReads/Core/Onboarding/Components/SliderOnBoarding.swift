//
//  SliderOnBoarding.swift
//  TinyReads
//
//  Created by user on 16.06.2026.
//

import SwiftUI

struct SliderOnBoarding: View {
  let onFinished: () -> ()
  @State private var animationDragGesture: CGFloat = 0
  
  @State private var cards: [DisplayReadCard] = DisplayReadCard.onBoardingCard
  
    var body: some View {
        SlideView(
		  readArray: cards,
		  onSave: removeCard,
		  onDismiss: removeCard,
		  onTap: nil
		)
		  .offset(x: animationDragGesture)
		  .onAppear{
			 withAnimation(.easeInOut(duration: 1).delay(1).repeatForever()) {
				animationDragGesture = cards.count > 1 ? 10 : -10
			 }
		  }
    }
}

// MARK: - Actions
private extension SliderOnBoarding {
  // Remove demo card after swipe
  func removeCard(_ id: String) {
	 cards.removeAll { $0.id == id }
	 
	 if cards.isEmpty {
		withAnimation(.easeInOut(duration: 0.8)){
		  onFinished()
		}
	 }
  }
}

#Preview {
  SliderOnBoarding {}
	 .environment(ThemeManager())
}
