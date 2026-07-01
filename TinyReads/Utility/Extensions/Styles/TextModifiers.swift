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

struct HeadLineViewModifier: ViewModifier{
  @Environment(ThemeManager.self) var themeManager
  let weight: Font.Weight
  func body(content: Content) -> some View {
	 content
		.font(.headline.weight(weight))
		.foregroundStyle(themeManager.themeAssets.primary)
		.fontDesign(.serif)
  }
}

struct AccentViewModifier: ViewModifier{
  @Environment(ThemeManager.self) var themeManager
  let weight: Font.Weight
  func body(content: Content) -> some View {
	 content
		.font(.headline.weight(weight))
		.foregroundStyle(themeManager.themeAssets.accent)
		.fontDesign(.serif)
  }
}

struct PrimaryViewModifier: ViewModifier{
  @Environment(ThemeManager.self) var themeManager
  let weight: Font.Weight
  func body(content: Content) -> some View {
	 content
		.fontWeight(weight)
		.foregroundStyle(themeManager.themeAssets.primary)
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
  
  func accent(weight: Font.Weight = .regular) -> some View{
	 modifier(AccentViewModifier(weight: weight))
  }
  
  func headline(weight: Font.Weight = .light) -> some View{
	 modifier(HeadLineViewModifier(weight: weight))
  }
  
  func regular(weight: Font.Weight = .regular) -> some View{
	 modifier(PrimaryViewModifier(weight: weight))
  }
}

