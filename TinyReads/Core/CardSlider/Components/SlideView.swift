//
//  SlideView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct SlideView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(CardSliderViewModel.self) var vm
  @State private var dragAmount: CGFloat = .zero
  
  private let swipeThreshold: CGFloat = 150
  var body: some View {
	 let assets = themeManager.themeAssets
	 ZStack{
		let activeTwo = Array(vm.cards.prefix(2))
		
		ForEach(activeTwo, id: \.id) { card in
		  let isTopCard = card.id == vm.cards.first?.id
		  
			  CardView(displayCard: card)
			 .padding(20)
			 .offset(x: isTopCard ? dragAmount / 2 : 0)
			 .scaleEffect(isTopCard ? 1.0 : backCardScale)
			 .opacity(isTopCard ? 1.0 : backCardOpacity)
			 .zIndex(isTopCard ? 2 : 1)
			 .gesture(isTopCard ? dragGesture(cardId: card.id) : nil)
		}
		 }
		 .overlay(alignment: slideHint?.alignment ?? .topTrailing) {
			if let slideHint {
			  Image(systemName: slideHint.iconName)
				 .font(.largeTitle)
				 .foregroundStyle(slideHint.color)
				 .padding()
				 .opacity(slideHintOpacity)
				 .scaleEffect(0.8 + slideHintOpacity * 0.2)
				 .zIndex(1)
			}
		 }
		 .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.75), value: dragAmount)
	  }
  
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
						 vm.onSave(cardId)
					  } else {
						 vm.onDismiss(cardId)
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

#Preview {
  SlideView()
	 .environment(CardSliderViewModel())
	 .environment(ThemeManager())
	 .environment(NavigationManager.shared)
}
