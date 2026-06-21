//
//  ReferencesProfileView.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

struct ReferencesProfileView: View {
  @Environment(ThemeManager.self) var themeManager
  let policyURL = URL(string: "https://github.com/Hiroio")!
  let termsOfUseURL = URL(string: "https://github.com/Hiroio")!
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
