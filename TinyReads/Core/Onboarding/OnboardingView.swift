//
//  OnboardingView.swift
//  TinyReads
//
//  Created by user on 14.06.2026.
//

import SwiftUI

struct OnboardingView: View {
  @Environment(UserDefaultsManager.self) var userDefaults
  @Environment(ThemeManager.self) var themeManager
  @Environment(NavigationManager.self) var navigationManager
  
  @State private var step: OnboardingStep = .welcome
  @State private var isLoading: Bool = true
  
  var body: some View {
	 ZStack {
		themeManager.themeAssets.background.ignoresSafeArea()
		
		VStack(spacing: 18) {
		  VStack(spacing: 8) {
			 Text("Tiny Reads")
				.title()
			 
			 Text(helpText)
				.secondary()
				.multilineTextAlignment(.center)
		  }
		  .padding(.horizontal, 24)
		  
		  ZStack {
			 SliderOnBoarding {
				step = .categories
			 }
			 .onboardingPage(isVisible: step == .practice)
			 
			 CategoriesView(secondary: false)
				.onboardingPage(isVisible: step == .categories)
		  }
		  let selectedCategoryActive = userDefaults.selectedCategories.count < 0
		  if step == .categories{
			 Button{
				userDefaults.onBoardingCompletion = true
			 }label: {
				Text("Complete")
				  .foregroundStyle(themeManager.themeAssets.card)
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 30)
						.fill(themeManager.themeAssets.accent)
				  )
			 }
			 .disabled(selectedCategoryActive)
			 .opacity(selectedCategoryActive ? 0.5 : 1)
		  }
		}
		.padding(.top, 32)
		
		loadingOverlay
	 }
	 .animation(.easeInOut(duration: 0.8), value: userDefaults.selectedCategories.count)
	 .animation(.easeInOut(duration: 0.45), value: step)
	 .animation(.easeInOut(duration: 0.6), value: isLoading)
	 .task {
		await startIntro()
	 }
  }
}

// MARK: - Components
private extension OnboardingView {
  // Header subtitle
  var helpText: String {
	 switch step {
	 case .welcome:
		"Short reads for curious minds."
	 case .practice:
		"Swipe cards"
	 case .categories:
		"Select categories you are interested in"
	 }
  }
  // Stable loading overlay
  var loadingOverlay: some View {
	 ZStack {
		themeManager.themeAssets.background.ignoresSafeArea()
		LoadingView()
	 }
	 .opacity(isLoading ? 1 : 0)
	 .allowsHitTesting(isLoading)
	 .zIndex(10)
  }
}

// MARK: - Actions
private extension OnboardingView {
  // Intro timing
  func startIntro() async {
	 guard isLoading else { return }
	 
	 try? await Task.sleep(for: .seconds(1))
	 isLoading = false
	 
	 try? await Task.sleep(for: .seconds(1))
	 step = .practice
  }
}

// MARK: - Helpers
private enum OnboardingStep {
  case welcome
  case practice
  case categories
}

private extension View {
  func onboardingPage(isVisible: Bool) -> some View {
	 self
		.opacity(isVisible ? 1 : 0)
		.scaleEffect(isVisible ? 1 : 0.96)
		.offset(y: isVisible ? 0 : 18)
		.allowsHitTesting(isVisible)
		.accessibilityHidden(!isVisible)
  }
}

#Preview {
  OnboardingView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
	 .environment(NavigationManager.shared)
}
