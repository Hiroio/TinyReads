//
//  NavigationManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation
import SwiftUI

@Observable
final class NavigationManager {
  static let shared = NavigationManager()
  
  private init(){}
  
  var loadingScreen: Bool = true
  var secondary: SecondaryAppScreen? = nil
  
  var article: ArticleRoute? = nil
  var highlight: HighlightScreenState? = nil
  
  
  var loading: Bool = false
  var popUpState: SmallPopUpEnum? = nil
  /// Keeps the auto-dismiss tied to the popup itself rather than to the view's lifecycle.
  @ObservationIgnored private var popUpTask: Task<Void, Never>? = nil

  var warning: WarningPopUpEnum? = nil
  var confirmationAction: (() -> Void)? = nil

  //  Registered by HighlightView so the outer background tap (owned by MainNavigationView)
  //  can go through the same unsaved-changes check as the in-view close button.
  var highlightExitAction: (() -> Void)? = nil
}


// MARK: - Small popup
extension NavigationManager {
  /// Shows a popup and restarts its countdown. Restarting matters: `onAppear` does not fire again
  /// when a second popup replaces one that is still on screen (or still animating away), so a
  /// view-owned timer would leave the new popup hanging there forever.
  func showPopUp(_ state: SmallPopUpEnum) {
	 popUpTask?.cancel()

	 withAnimation {
		popUpState = state
	 }

	 popUpTask = Task { @MainActor [weak self] in
		try? await Task.sleep(for: .seconds(1.8))
		guard !Task.isCancelled else { return }

		withAnimation {
		  self?.popUpState = nil
		}
	 }
  }

  func hidePopUp() {
	 popUpTask?.cancel()
	 popUpTask = nil

	 withAnimation {
		popUpState = nil
	 }
  }
}


extension NavigationManager {
  func showWarning(_ type: WarningPopUpEnum, confirmationAction: @escaping () -> Void) {
	 self.warning = type
	 self.confirmationAction = confirmationAction
  }

  func dismissWarning() {
	 warning = nil
	 confirmationAction = nil
  }
}
