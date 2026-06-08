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

  init(error: CardError, retryAction: @escaping () -> Void = {}) {
	 self.error = error
	 self.retryAction = retryAction
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
			 Button {
				switch error {
				case .badInternetConnection:
				  retryAction()
				case .somethingWentWrong:
				  retryAction()
				case .cardNoLeft:
				  NavigationManager.shared.secondary = .category
				}
			 } label: {
				Text(error.buttonTitle)
				  .accent(weight: .semibold)
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
}

#Preview {
  CardErrorHandlingView(error: .cardNoLeft)
	 .environment(ThemeManager())
}
