//
//  TinyReadsApp.swift
//  TinyReads
//
//  Created by user on 28.05.2026.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct TinyReadsApp: App {
  @State private var navigationManager = NavigationManager.shared
  @State private var themeManager = ThemeManager()
  init(){
	 FirebaseApp.configure()
	 
	 Task{
		try? await FirebaseAuthService.shared.ensureAnonymousUser()
	 }
  }
    var body: some Scene {
        WindowGroup {
            MainView()
				.environment(navigationManager)
				.environment(themeManager)
        }
    }
}
