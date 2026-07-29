//
//  TinyReadsWidgetsBundle.swift
//  TinyReadsWidgets
//
//  Created by user on 28.07.2026.
//

import WidgetKit
import SwiftUI
import FirebaseCore

@main
struct TinyReadsWidgetsBundle: WidgetBundle {
  init() {
	 FirebaseApp.configure()
  }
  var body: some Widget {
	 ArticleWidget()
	 HighlightWidget()
  }
}	
