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
  
  var loading: Bool = false
}
