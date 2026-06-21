//
//  AccessibilityViewModifiers.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

extension View {
  func tinyAccessibilityButton(
	 _ label: LocalizedStringKey,
	 hint: LocalizedStringKey? = nil
  ) -> some View {
	 self
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(label)
		.accessibilityAddTraits(.isButton)
		.accessibilityHint(hint ?? "")
  }
  
  func tinyAccessibilityImage(_ label: LocalizedStringKey) -> some View {
	 self
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(label)
		.accessibilityAddTraits(.isImage)
  }
  
  func tinyAccessibilityHidden() -> some View {
	 self.accessibilityHidden(true)
  }
}
