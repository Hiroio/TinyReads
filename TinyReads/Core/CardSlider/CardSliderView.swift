//
//  CardSliderView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardSliderView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @State private var vm = CardSliderViewModel()
  @Binding var active: Bool
    var body: some View {
		ZStack{
		  themeManager.themeAssets.background.ignoresSafeArea()
		  VStack{
			 if vm.fetchIsActive && vm.cards.isEmpty{
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
					 NavigationManager.shared.secondary = .category
				  }
				)
			 }else{
				VStack{
				  SlideView()
					 .environment(vm)
				}
			 }
		  }
		  .frame(maxHeight: .infinity)
		  .onChange(of: userDefaultManager.selectedCategories, { _, _ in
			 Task{
				await vm.reloadCards()
			 }
		  })
		  .overlay(
			 Group{
				if !active{
				Button{
				  vm.changeDeckMode()
				}label: {
				  Image(systemName: vm.deckMode.image)
					 .font(.headline.weight(.light))
					 .padding()
					 .foregroundStyle(themeManager.themeAssets.primary)
				}
				.transition(.move(edge: .top).combined(with: .opacity))
			 }
			 }
			 , alignment: .topTrailing)
		}
		.animation(.easeInOut, value: vm.deckMode)
		.animation(.easeInOut, value: active)
    }
}

#Preview {
  CardSliderView(active: .constant(false))
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
}
