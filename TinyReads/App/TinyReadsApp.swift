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
  @State private var userDefaultManager = UserDefaultsManager.shared
  @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
  init(){
	 FirebaseApp.configure()
	 let _ = ReadsDeckManager.shared
	 Task{
		try? await FirebaseAuthService.shared.ensureAnonymousUser()
	 }
  }
    var body: some Scene {
        WindowGroup {
			 UploaderView()
				.environment(navigationManager)
				.environment(themeManager)
				.environment(userDefaultManager)
				.environment(\.locale, Locale(identifier: selectedLanguage))
        }
    }
}
