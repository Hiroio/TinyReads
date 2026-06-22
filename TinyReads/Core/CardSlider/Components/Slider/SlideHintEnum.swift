//
//  SlideHintEnum.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import SwiftUI

enum SlideHint {
  case archive
  case dismiss

  var iconName: String {
    switch self {
    case .archive:
      "SaveAction"
    case .dismiss:
      "DismissAction"
    }
  }

  var color: Color {
    switch self {
    case .archive:
      .cyan
    case .dismiss:
      .red
    }
  }

  var alignment: Alignment {
    switch self {
    case .archive:
      .topTrailing
    case .dismiss:
      .topLeading
    }
  }
}
