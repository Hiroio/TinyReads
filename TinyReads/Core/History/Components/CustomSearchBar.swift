//
//  CustomSearchBar.swift
//  TinyReads
//
//  Created by user on 01.07.2026.
//

import SwiftUI

struct CustomSearchBar: View {
  @Environment(ThemeManager.self) var theme
  @Binding var searchText: String
    var body: some View {
		HStack{

		  TextField("", text: $searchText, prompt: Text("Enter key words...").foregroundStyle(theme.themeAssets.secondary))
			 .chatTextFieldStyle()
			 .foregroundStyle(theme.themeAssets.accent)
			 .fontDesign(.serif)
			 .accentColor(theme.themeAssets.accent)
		  
		  
		}
		.frame(maxWidth: .infinity)
		.scaledToFit()
		.padding()
		
    }
}

#Preview {
  CustomSearchBar(searchText: .constant(""))
	 .environment(ThemeManager())
}
