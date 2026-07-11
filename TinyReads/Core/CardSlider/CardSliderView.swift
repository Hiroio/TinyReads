//
//  CardSliderView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardSliderView: View {
  @Binding var active: Bool
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @Environment(NavigationManager.self) var navigationManager
  @Environment(CardSliderViewModel.self) var vm
  var body: some View {
	 ZStack{
		themeManager.themeAssets.background.ignoresSafeArea()
		VStack{
		  switch vm.deckMode{
		  case .freshOnly:
			 FreshSliderView()
				.transition(.move(edge: .leading))
		  case .repeatOld:
			 ViewedSliderView()
				.transition(.move(edge: .trailing))
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.overlay(alignment: .topTrailing){
		  CloseButton
		}
		.overlay(alignment: .bottomTrailing){
		  ModeButton
		}
		.animation(.easeInOut, value: vm.deckMode)
		.animation(.easeInOut, value: vm.repeatDisplayReads.count)
		.animation(.easeInOut, value: vm.freshDisplayReads.count)
		.animation(.easeInOut, value: vm.cards)
		.animation(.easeInOut, value: vm.fetchIsActive)
		.animation(.easeInOut, value: active)
	 }
  }
}

#Preview {
  CardSliderView(active: .constant(false))
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
	 .environment(CardSliderViewModel())
}



// MARK: - Actions
private extension CardSliderView {
  @ViewBuilder
  private var CloseButton: some View {
	 if !active{
		Button{
		  active = true
		}label:{
		  Image(systemName: "xmark")
		}
		.tinyAccessibilityButton("Close reader controls")
		.font(.headline.weight(.light))
		.padding()
		.foregroundStyle(themeManager.themeAssets.primary)
		.transition(.move(edge: .top).combined(with: .opacity))
	 }
  }

  @ViewBuilder
  private var ModeButton: some View {
	 let image = vm.deckMode == .freshOnly ? themeManager.themeAssets.freshSwipeMode : themeManager.themeAssets.repeatSwipeMode
	 if !active{
		Button{
		  vm.changeDeckMode()
		}label: {
		  Image(image)
			 .resizable()
			 .scaledToFit()
			 .frame(width: 45)
		}
		.tinyAccessibilityButton(vm.deckMode.accessibilityLabel, hint: vm.deckMode.accessibilityHint)
		.font(.headline.weight(.light))
		.padding()
		.foregroundStyle(themeManager.themeAssets.primary)
		.transition(.move(edge: .bottom).combined(with: .opacity))
	 }
  }
}
