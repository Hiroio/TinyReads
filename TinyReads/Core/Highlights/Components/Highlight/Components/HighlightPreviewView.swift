//
//  HighlightPreviewView.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import SwiftUI

struct HighlightPreviewView: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var viewModel: HighlightActionViewModel
    var body: some View {
		let extended = viewModel.text.count > 150
		VStack(spacing: 0){
		  Button{
			 viewModel.navigateToArticle()
		  }label: {
			 Text(viewModel.highlight.originalTitle)
				.font(UIDevice.isIPad ? .headline : .caption)
				.underline()
				.secondary()
		  }
		  Spacer()
		  
		  Text(viewModel.text.capitalized)
			 .font(UIDevice.isIPad ? .title2 : .footnote)
			 .padding(25)
			 .accent(weight: .medium)
			 .kerning(1.1)
			 .lineSpacing(1.5)
			 .frame(maxHeight: .infinity)
			 .allowsTightening(true)
			 .minimumScaleFactor(0.7)
			 .multilineTextAlignment(.center)
		  
		  Spacer()
		  
		  Button{
			 viewModel.note.toggle()
		  }label:{
			 Text("Leave a note")
				.font(UIDevice.isIPad ? .footnote : .caption)
				.accent()
				.underline()
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
		.padding(.vertical, 45)
		.aspectRatio(UIDevice.isIPad ? 1.3 : 1, contentMode: .fit)
		.background(
		  Image(extended ? themeManager.themeAssets.backCard : themeManager.themeAssets.backSmallCard)
			 .resizable()
		)
    }
}

#Preview {
  HighlightPreviewView(viewModel: HighlightActionViewModel(highlight: .preview, state: .create(.preview)))
	 .environment(ThemeManager())
}
