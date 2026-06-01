//
//  NavigationManager.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation

enum AppScreen{
  case main, slide, archive, dismissed, categories, publicCategories
}
enum SecondaryAppScreen{
  case profile
}

@Observable
final class NavigationManager {
  var screen: AppScreen = .main
  var secondary: SecondaryAppScreen? = nil
  
  var article: ReadCardModel? = nil
  
  
}
