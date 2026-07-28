//
//  ArticleWidgetView.swift
//  TinyReads
//
//  Created by user on 28.07.2026.
//

import SwiftUI
import WidgetKit


struct ArticleWidgetView: View {
  @Environment(\.widgetFamily) var widgetFamily
  @Environment(\.colorScheme) var colorScheme
  let entry: ArticleEntry
  var body: some View {
	 Text(entry.article.title)
		.font(widgetFamily == .systemSmall ? .footnote.weight(.semibold) : .title2.weight(.semibold))
		.foregroundStyle(.primary)
		.fontDesign(.serif)
		.multilineTextAlignment(.center)
		.padding()
		.padding(.horizontal, widgetFamily != .systemSmall ? 15 : 0)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
		  Image(backgroundImageName)
			 .resizable()
		)
    }

  private var backgroundImageName: String {
	 let theme = colorScheme == .dark ? "Dark" : ""
	 let base = widgetFamily == .systemMedium ? "ReaderCard" : "SavedBackWidget"
	 return base + theme
  }
}

#Preview {
  ArticleWidgetView(entry: ArticleEntry(date: .now, article: .getForPreview()))
}
