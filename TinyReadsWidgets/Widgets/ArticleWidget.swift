//
//  ArticleWidget.swift
//  TinyReads
//
//  Created by user on 28.07.2026.
//

import WidgetKit
import SwiftUI


struct ArticleWidget: Widget {
	 let kind: String = "Article Widget"

	 var body: some WidgetConfiguration {
		  StaticConfiguration(kind: kind, provider: ArticleProvider()) { entry in
				if #available(iOS 17.0, *) {
					 ArticleWidgetView(entry: entry)
					 .containerBackground(for: .widget){
						Color.clear
					 }
				} else {
				  ArticleWidgetView(entry: entry)
				}
		  }
		  .configurationDisplayName("Random Article")
		  .description("A short article to read, refreshed regularly")
	 }
}

#Preview(as: .systemSmall) {
  ArticleWidget()
} timeline: {
  ArticleEntry(date: .now, article: .getForPreview())
}
