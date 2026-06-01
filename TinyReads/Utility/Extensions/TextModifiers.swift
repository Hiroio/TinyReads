//
//  TextModifiers.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import Foundation
import SwiftUI


struct TitleViewModifier: ViewModifier{
  @Environment(ThemeManager.self) var themeManager
  let weight: Font.Weight
  func body(content: Content) -> some View {
	 content
		.font(.title2.weight(weight))
		.foregroundStyle(themeManager.themeAssets.primary)
		.fontDesign(.serif)
  }
}
struct SecondaryViewModifier: ViewModifier{
  @Environment(ThemeManager.self) var themeManager
  let weight: Font.Weight
  func body(content: Content) -> some View {
	 content
		.font(.footnote.weight(weight))
		.foregroundStyle(themeManager.themeAssets.secondary)
		.fontDesign(.serif)
  }
}

extension View{
  func title(weight: Font.Weight = .regular) -> some View{
	 modifier(TitleViewModifier(weight: weight))
  }
  
  
  func secondary(weight: Font.Weight = .regular) -> some View{
	 modifier(SecondaryViewModifier(weight: weight))
  }
}

