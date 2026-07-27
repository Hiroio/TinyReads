//
//  ButtonStyles.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import Foundation
import SwiftUI


struct SmallBtnStyle: ButtonStyle{
  @Environment(ThemeManager.self) var themeManager
  func makeBody(configuration: Configuration) -> some View {
	 configuration.label
		.padding(10)
		.foregroundStyle(themeManager.themeAssets.accent)
		.background(
		  Image(themeManager.themeAssets.readerCard)
			 .resizable()
			 .shadow(radius: 1)
		)
		.scaleEffect(configuration.isPressed ? 0.85 : 1.0)
		.animation(.smooth, value: configuration.isPressed)
  }
}

struct CircleBtnStyle: ButtonStyle{
  @Environment(ThemeManager.self) var themeManager
  func makeBody(configuration: Configuration) -> some View {
	 configuration.label
		.padding()
		.background(
		  NotRoundCircle()
			 .stroke(lineWidth: 2)
		)
		.scaleEffect(configuration.isPressed ? 0.85 : 1.0)
		.animation(.smooth, value: configuration.isPressed)
  }
}
