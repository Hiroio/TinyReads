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
		
		VStack(spacing: 15) {
		  VStack(spacing: 10) {
			 Text("Tiny Reads")
				.title()
			 
			 Text(helpText)
				.secondary()
				.multilineTextAlignment(.center)
		  }
		  .padding(.horizontal, 24)
		  
		  switch step {
		  case .welcome:
			 loadingOverlay
		  case .practice:
			 SliderOnBoarding {
				step = .categories
			 }
			 .aspectRatio(1/1.5 ,contentMode: .fit)
			 .transition(.opacity)
		  case .categories:
			 VStack{
				OnBoardingCategoryView()
				  .geometryGroup()
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
				  .aspectRatio(1/1.5 ,contentMode: .fit)
				compelitionBtn
			 }
			 .transition(.move(edge: .bottom))
		  case .finale:
			 EmptyView()
		  }
		  
		 
		}
		.padding(.top, 32)
	 }
	 .animation(.easeInOut(duration: 0.4), value: isLoading)
	 
	 .task {
		await startIntro()
	 }
  }
  //	 .animation(.easeInOut(duration: 0.8), value: userDefaults.selectedCategories.count)
  
}

// MARK: - Components
private extension OnboardingView {
  // Header subtitle
  var helpText: LocalizedStringKey {
	 switch step {
	 case .welcome:
		"Short reads for curious minds."
	 case .practice:
		"Swipe cards"
	 case .categories:
		"Select categories you are interested in"
	 case .finale:
		"That's it!\n Everything is simple."
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
  
  private var compelitionBtn: some View{
	 VStack{
		let selectedCategoryActive = userDefaults.selectedSubCategories.count > 0
		Button{
		  if selectedCategoryActive{
			 userDefaults.onBoardingCompletion = true
		  }
		}label: {
		  Text("Complete")
			 .foregroundStyle(themeManager.themeAssets.card)
			 .padding()
			 .background(
				RoundedRectangle(cornerRadius: 30)
				  .fill(themeManager.themeAssets.accent)
			 )
		}
		.disabled(!selectedCategoryActive)
		.opacity(!selectedCategoryActive ? 0.5 : 1)
		Text("Choose at least one category to start")
		  .font(.caption)
		  .foregroundStyle(themeManager.themeAssets.secondary)
	 }
  }
}

// MARK: - Helpers
private enum OnboardingStep {
  case welcome
  case practice
  case categories
  case finale
}

private extension View {
  func onboardingPage(isVisible: Bool) -> some View {
	 self
		.opacity(isVisible ? 1 : 0)
		.scaleEffect(isVisible ? 1 : 0.96)
		.offset(y: isVisible ? 0 : 200)
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
