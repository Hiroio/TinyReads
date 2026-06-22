//
//  FreshSliderView.swift
//  TinyReads
//
//  Created by user on 22.06.2026.
//

import SwiftUI

struct FreshSliderView: View {
  @Environment(CardSliderViewModel.self) var vm
  var body: some View {
	 ZStack{
		if let error = vm.errorState{
		  CardErrorHandlingView(error: error, retryAction: {
			 vm.fetchCards()
		  }, reshuffleAction: {
			 vm.changeDeckMode()
		  }, selectCategoriesAction: {
			 NavigationManager.shared.secondary = .category
		  })
			 .transition(.move(edge: .bottom).combined(with: .opacity))
			 .zIndex(1)
			 .allowsHitTesting(vm.errorState != nil)
		}else{
		  if vm.fetchIsActive{
			 LoadingView()
		  }else{
			 if vm.freshDisplayReads.isEmpty{
				CardErrorHandlingView(error: .badInternetConnection)
				  .transition(.move(edge: .bottom).combined(with: .opacity))
				  .zIndex(1)
				  .allowsHitTesting(vm.freshDisplayReads.isEmpty)
			 }else{
				SlideView(
				  readArray: vm.freshDisplayReads,
				  onSave: vm.onSave,
				  onDismiss: vm.onDismiss,
				  onTap: vm.openArticle
				)
			 }
		  }
		}
	 }
  }
}

#Preview {
  FreshSliderView()
	 .environment(CardSliderViewModel())
	 .environment(ThemeManager())
}
