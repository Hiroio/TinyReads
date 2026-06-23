//
//  ReferencesProfileView.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

struct ReferencesProfileView: View {
  @Environment(ThemeManager.self) var themeManager
  let policyURL = URL(string: "https://hiroio.github.io/tinyreads-legal/privacy.html")!
  let termsOfUseURL = URL(string: "https://hiroio.github.io/tinyreads-legal/terms.html")!
    var body: some View {
		HStack(spacing: 10){
		  Link(destination: policyURL) {
			 Text("Privacy Policy")
				.secondary()
		  }
		  
		  Circle()
			 .fill(themeManager.themeAssets.primary)
			 .frame(width: 5)
		  
		  Link(destination: termsOfUseURL) {
			 Text("Terms of use")
				.secondary()
		  }
		}
    }
}

#Preview {
    ReferencesProfileView()
	 .environment(ThemeManager())
}
