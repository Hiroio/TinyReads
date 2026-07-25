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
		  Text(viewModel.highlight.originalTitle)
			 .secondary()
		  Spacer()
		  
		  Text(viewModel.text.capitalized)
			 .padding(25)
			 .accent(weight: .medium)
			 .kerning(1.1)
			 .lineSpacing(4)
			 .frame(maxHeight: .infinity)
			 .multilineTextAlignment(.center)
		  
		  Spacer()
		  
		  Button{
			 viewModel.note.toggle()
		  }label:{
			 Text("Leave a note")
				.font(.caption)
				.accent()
				.underline()
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
		.padding(.vertical, 45)
		.aspectRatio(1.1, contentMode: .fit)
		.background(
		  Image(extended ? themeManager.themeAssets.backCard : themeManager.themeAssets.backSmallCard)
			 .resizable()
		)
    }
}

#Preview {
  HighlightPreviewView(viewModel: HighlightActionViewModel(highlight: .preview, state: .create(.preview)))
}
