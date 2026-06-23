//
//  CardEmptyState.swift
//  TinyReads
//
//  Created by user on 20.06.2026.
//

import SwiftUI

struct CardEmptyState: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(CardSliderViewModel.self) var vm
  var body: some View {
	 VStack{
		Image(themeManager.themeAssets.emptyState)
		  .resizable()
		  .scaledToFit()
		  .aspectRatio(0.5, contentMode: .fit)
		  .frame(maxHeight: .infinity)
		VStack{
		  Text("There is nothing to show here!")
			 .headline(weight: .semibold)
		  Text("Swipe some pages to get something here!")
			 .secondary(weight: .medium)
		  
		  if !vm.cards.isEmpty {
			 Button{
				vm.refreshActiveStatus()
			 }label: {
				Text("Reshuffle")
				  .accent()
				  .padding(.top)
			 }
		  }
		}
		.padding(.bottom, 40)
		.multilineTextAlignment(.center)
	 }
	 .padding()
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .aspectRatio(0.7, contentMode: .fit)
	 .background(
		Image(themeManager.themeAssets.backCard)
		  .resizable(resizingMode: .stretch)
	 )
	 .padding(20)
	 .compositingGroup()
	 .shadow(radius: 5)
  }
}

#Preview {
  CardEmptyState()
	 .environment(ThemeManager())
	 .environment(CardSliderViewModel())
}
