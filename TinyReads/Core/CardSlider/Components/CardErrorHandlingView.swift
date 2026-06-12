//
//  CardErrorHandlingView.swift
//  TinyReads
//
//  Created by user on 02.06.2026.
//

import SwiftUI

struct CardErrorHandlingView: View {
  @Environment(ThemeManager.self) var themeManager
  let error: CardError
  let retryAction: () -> Void
  let reshuffleAction: () -> Void
  let selectCategoriesAction: () -> Void

  init(
	 error: CardError,
	 retryAction: @escaping () -> Void = {},
	 reshuffleAction: @escaping () -> Void = {},
	 selectCategoriesAction: @escaping () -> Void = {}
  ) {
	 self.error = error
	 self.retryAction = retryAction
	 self.reshuffleAction = reshuffleAction
	 self.selectCategoriesAction = selectCategoriesAction
  }

    var body: some View {
		let themeAssets = themeManager.themeAssets
        VStack(spacing: 25) {
			 Image(error.imageName)
				.resizable()
				.scaledToFit()
				.aspectRatio(0.45, contentMode: .fit)
			 
			 VStack{
				Text(error.title)
				  .title(weight: .semibold)
				  .multilineTextAlignment(.center)
				
				Text(error.subtitle)
				  .secondary()
				  .multilineTextAlignment(.center)
			 }
			 VStack(spacing: 12) {
				Button {
				  primaryAction()
				} label: {
				  Text(error.primaryButtonTitle)
					 .accent(weight: .semibold)
				}
				
				if let secondaryButtonTitle = error.secondaryButtonTitle {
				  Button {
					 selectCategoriesAction()
				  } label: {
					 Text(secondaryButtonTitle)
						.secondary(weight: .semibold)
				  }
				}
			 }
		  }
		  .padding()
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  .background(
			 Image(themeAssets.backCard)
				.resizable()
				.scaledToFit()
		  )
	    }
  
  private func primaryAction() {
	 switch error {
	 case .badInternetConnection, .somethingWentWrong:
		retryAction()
	 case .cardNoLeft:
		reshuffleAction()
	 case .noCategories:
		selectCategoriesAction()
	 }
  }
}

#Preview {
  CardErrorHandlingView(error: .cardNoLeft)
	 .environment(ThemeManager())
}
