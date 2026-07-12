//
//  ReferencesProfileView.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

struct ReferencesProfileView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(StoreKitManager.self) var storeKit
  let policyURL = URL(string: "https://hiroio.github.io/tinyreads-legal/privacy.html")!
  let termsOfUseURL = URL(string: "https://hiroio.github.io/tinyreads-legal/terms.html")!
    var body: some View {
		VStack{
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
		  
		  Button{
			 Task{
				await storeKit.restorePurchases()
			 }
		  }label:{
			 Text("Restore Purchases")
				.secondary()
				.underline(true)
		  }
		}
    }
}

#Preview {
    ReferencesProfileView()
	 .environment(ThemeManager())
	 .environment(StoreKitManager.shared)
}
