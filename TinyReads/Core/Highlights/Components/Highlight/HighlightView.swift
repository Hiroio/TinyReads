//
//  HighlightView.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import SwiftUI

struct HighlightView: View {
  @Environment(ThemeManager.self) var themeManager
  @Binding var text: String
    var body: some View {
		let expanded = text.count > 150
		VStack{
		  Text("Highlight")
			 .title()
		  
		  TextField("", text: $text, axis: .vertical)
			 .padding(25)
			 .accent(weight: .light)
			 .kerning(1.1)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
		.aspectRatio(expanded ? 0.7 : 1.1, contentMode: .fit)
		.background(
		  Image(expanded ? themeManager.themeAssets.backCard : themeManager.themeAssets.backSmallCard)
			 .resizable()
		)
		.padding(.horizontal, expanded ? 10 : 20)
		.animation(.easeInOut, value: expanded)
    }
}

#Preview {
  @Previewable @State var text: String = ""
    HighlightView(text: $text)
	 .environment(ThemeManager())
}
