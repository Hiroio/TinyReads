//
//  SlideView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct SlideView: View {
  let readArray: [DisplayReadCard]
  let onSave: (String) -> ()
  let onDismiss: (String) -> ()
  let onTap: ((String) -> ())?
  
  @State private var dragAmount: CGFloat = .zero
  
  private let swipeThreshold: CGFloat = 150
  
  init(
	 readArray: [DisplayReadCard],
	 onSave: @escaping (String) -> (),
	 onDismiss: @escaping (String) -> (),
	 onTap: ((String) -> ())? = nil
  ) {
	 self.readArray = readArray
	 self.onSave = onSave
	 self.onDismiss = onDismiss
	 self.onTap = onTap
  }
  
  var body: some View {
	 ZStack{
		let activeTwo = Array(readArray.prefix(2))
		
		ForEach(activeTwo, id: \.id) { card in
		  let isTopCard = card.id == readArray.first?.id
		  
		  CardView(displayCard: card, showsTapHint: onTap != nil)
			 .padding(20)
			 .offset(x: isTopCard ? dragAmount / 2 : 0)
			 .scaleEffect(isTopCard ? 1.0 : backCardScale)
			 .opacity(isTopCard ? 1.0 : backCardOpacity)
			 .zIndex(isTopCard ? 2 : 1)
			 .gesture(isTopCard ? dragGesture(cardId: card.id) : nil)
			 .onTapGesture {
				guard isTopCard, abs(dragAmount) < 2 else { return }
				onTap?(card.id)
			 }
		}
	 }
	 .accessibilityElement(children: .contain)
	 .accessibilityLabel("Reading card deck")
	 .accessibilityHint("Swipe right to save, swipe left to dismiss, or double tap to read.")
	 .overlay(alignment: slideHint?.alignment ?? .topTrailing) {
		if let slideHint {
		  Image(slideHint.iconName)
			 .resizable()
			 .scaledToFit()
			 .frame(width: 80)
			 .padding()
			 .opacity(slideHintOpacity)
			 .scaleEffect(0.8 + slideHintOpacity * 0.3)
			 .zIndex(1)
			 .offset(y: -80)
			 .tinyAccessibilityHidden()
		}
	 }
	 .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.75), value: dragAmount)
  }
}

#Preview {
  SlideView(
	 readArray: DisplayReadCard.onBoardingCard,
	 onSave: { _ in },
	 onDismiss: { _ in },
	 onTap: nil
  )
	 .environment(ThemeManager())
}




extension SlideView{
  private func dragGesture(cardId: String) -> some Gesture {
	 DragGesture()
		.onChanged { value in
		  dragAmount = value.translation.width
		}
		.onEnded { value in
		  let width = value.translation.width
		  
		  if abs(width) > swipeThreshold {
			 let screenWidth = UIScreen.main.bounds.width
			 let targetX = width > 0 ? screenWidth : -screenWidth
			 
			 withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
				dragAmount = targetX
			 }
			 
			 DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				var transaction = Transaction()
				transaction.disablesAnimations = true
				
				withTransaction(transaction) {
				  if width > 0 {
					 onSave(cardId)
				  } else {
					 onDismiss(cardId)
				  }
				  dragAmount = 0
				}
			 }
		  } else {
			 withAnimation(.interactiveSpring()) {
				dragAmount = 0
			 }
		  }
		}
  }
  
  var backCardScale: Double {
	 let startScale: Double = 0.8
	 let scaleThreshold = swipeThreshold * 2
	 let progress = min(abs(dragAmount) / scaleThreshold, 1.0)
	 
	 return startScale + (progress * (1.0 - startScale))
  }
  
  var backCardOpacity: Double {
	 let startOpacity: Double = 0.4
	 let opacityThreshold = swipeThreshold * 2
	 let progress = min(abs(dragAmount) / opacityThreshold, 1.0)
	 
	 return startOpacity + (progress * (1.0 - startOpacity))
  }
  
  private var slideHint: SlideHint? {
	 if dragAmount > 50 {
		.archive
	 } else if dragAmount < -50 {
		.dismiss
	 } else {
		nil
	 }
  }
  
  private var slideHintOpacity: Double {
	 min(max((abs(dragAmount) - 50) / 80, 0), 1)
  }
}
