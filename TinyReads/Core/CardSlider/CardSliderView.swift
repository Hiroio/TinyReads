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
		  if vm.fetchIsActive {
			 LoadingView()
		  }else if let error = vm.errorState{
			 CardErrorHandlingView(
				error: error,
				retryAction: {
				  vm.fetchCards()
				},
				reshuffleAction: {
				  vm.reshuffleViewed()
				},
				selectCategoriesAction: {
				  navigationManager.secondary = .category
				}
			 )
			 .compositingGroup()
			 .transition(.move(edge: .bottom))
			 .zIndex(1)
			 .allowsHitTesting(vm.errorState != nil)
		  }else if vm.cards.isEmpty{
			 CardEmptyState()
		  }else{
			 VStack{
				SlideView(
				  readArray: vm.cards,
				  onSave: vm.onSave,
				  onDismiss: vm.onDismiss,
				  onTap: openArticle
				)
			 }
		  }
		}
		.frame(maxHeight: .infinity)
		.overlay(alignment: .topTrailing){
		  Group{
			 if !active{
				HStack{
				  Button{
					 active = true
				  }label:{
					 Image(systemName: "xmark")
						.frame(maxWidth: .infinity, alignment: .leading)
				  }
				  
				  Spacer()
				  Button{
					 vm.changeDeckMode()
				  }label: {
					 Image(systemName: vm.deckMode.image)
					 
				  }
				}
				.font(.headline.weight(.light))
				.padding()
				.foregroundStyle(themeManager.themeAssets.primary)
				.transition(.move(edge: .top).combined(with: .opacity))
			 }
		  }
		}
		.animation(.easeInOut, value: vm.deckMode)
		.animation(.easeInOut, value: vm.cards.count)
		.animation(.easeInOut, value: vm.fetchIsActive)
		.animation(.easeInOut, value: active)
	 }
  }
}

// MARK: - Actions
private extension CardSliderView {
  // Open article from top card
  func openArticle(_ id: String) {
	 guard let route = vm.articleRoute(for: id) else { return }
	 navigationManager.article = route
  }
}

#Preview {
  CardSliderView(active: .constant(false))
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
	 .environment(CardSliderViewModel())
}
