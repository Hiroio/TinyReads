//
//  NavigationManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation

enum AppScreen{
  case main, slide, archive, dismissed, publicCategories
}
enum SecondaryAppScreen{
  case profile
  case category
  case dismissed
  case archive
}

@Observable
final class NavigationManager {
  static let shared = NavigationManager()
  
  private init(){}
  
  var screen: AppScreen = .main
  var secondary: SecondaryAppScreen? = nil
  
  var article: ArticleRoute? = nil
  
  var loading: Bool = false
}
