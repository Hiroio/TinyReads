//
//  HighlightNoteView.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import SwiftUI

struct HighlightNoteView: View {
  @Environment(ThemeManager.self) var themeManager
  @Bindable var viewModel: HighlightActionViewModel
  @State private var extended: Bool = false
    var body: some View {
		  VStack{
			 VStack(spacing: 0){
				  Text(viewModel.highlight.originalTitle)
					 .secondary()
				Text(viewModel.text.capitalized)
				  .padding(10)
				  .overlay(
					 alignment: .bottom
				  ){
					 Image(systemName: "chevron.down")
						.font(.caption)
						.rotationEffect(Angle(degrees: extended ? 180 : 0))
				  }
				  .padding(10)
				  .font(extended ? .footnote : .caption)
				  .foregroundStyle(themeManager.themeAssets.accent)
				  .kerning(extended ? 1.2 : 0.9)
				  .lineSpacing(1)
				  .multilineTextAlignment(.center)
				  .lineLimit(extended ? nil : 3)
				  .onTapGesture {
					 withAnimation {
						extended.toggle()
					 }
				  }
				 
				
				NoteTextViewRepresentable(text: $viewModel.highlight.note, textColor: themeManager.themeAssets.primary, lineColor: themeManager.themeAssets.accent)
				  .padding()
				  .padding(.horizontal, UIDevice.isIPad ? 55 : 20)
				
				
			 }
			 .frame(maxWidth: .infinity, maxHeight: .infinity)
			 .padding()
			 .padding(.vertical, 45)
			 .aspectRatio(0.8, contentMode: .fit)
			 .background(
				Image(themeManager.themeAssets.backCard)
				  .resizable()
			 )
		  }
		  .padding(.horizontal, 20)
		}
}

#Preview {
  HighlightNoteView(viewModel: HighlightActionViewModel(highlight: .preview, state: .create(.preview)))
	 .environment(ThemeManager())
}
