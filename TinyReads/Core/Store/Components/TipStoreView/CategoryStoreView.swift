//
//  CategoryStoreView.swift
//  TinyReads
//
//  Created by user on 08.07.2026.
//

import SwiftUI

struct CategoryStoreView: View {
  @Environment(ThemeManager.self) var themeManager
    var body: some View {
		VStack{
		  Text("Will be available soon...")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(contentMode: .fit)
		.background(
		  Image(themeManager.themeAssets.backCard)
			 .resizable()
			 .scaledToFit()
		)
    }
}

#Preview {
    CategoryStoreView()
	 .environment(ThemeManager())
}
