//
//  OnboardingView.swift
//  TinyReads
//
//  Created by user on 14.06.2026.
//

import SwiftUI

struct OnboardingView: View {
  @Environment(ThemeManager.self) var themeManager
    var body: some View {
		ZStack{
		  themeManager.themeAssets.background.ignoresSafeArea()
		  
		  VStack{
			 Text("Tiny Reads")
				.title()
			 
			 Image("Loading0")
				.resizable()
				.scaledToFit()
		  }
		}
    }
}

#Preview {
    OnboardingView()
	 .environment(ThemeManager())
}
