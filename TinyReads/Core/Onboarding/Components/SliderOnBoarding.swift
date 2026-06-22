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
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Actions
private extension SliderOnBoarding {
  // Remove demo card after swipe
  func removeCard(_ id: String) {
	 cards.removeAll { $0.id == id }
	 
	 if cards.isEmpty {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
		  withAnimation(.easeInOut(duration: 0.45)){
			 onFinished()
		  }
		}
	 }
  }
}

#Preview {
  SliderOnBoarding {}
	 .environment(ThemeManager())
}
