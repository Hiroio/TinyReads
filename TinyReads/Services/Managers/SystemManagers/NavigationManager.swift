//
//  NavigationManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation

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

  var warning: WarningPopUpEnum? = nil
  var confirmationAction: (() -> Void)? = nil

  //  Registered by HighlightView so the outer background tap (owned by MainNavigationView)
  //  can go through the same unsaved-changes check as the in-view close button.
  var highlightExitAction: (() -> Void)? = nil
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
