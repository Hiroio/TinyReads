//
//  HiglightWidget.swift
//  TinyReads
//
//  Created by user on 29.07.2026.
//

import WidgetKit
import SwiftUI


struct HighlightWidget: Widget {
	 let kind: String = "Highlight Widget"

	 var body: some WidgetConfiguration {
		  StaticConfiguration(kind: kind, provider: HighlightProvider()) { entry in
				if #available(iOS 17.0, *) {
					 HighlightWidgetView(entry: entry)
					 .widgetURL(URL(string: "tinyreads://highlight?id=\(entry.highlight.id)"))
					 .containerBackground(for: .widget){
						Color.clear
					 }
				} else {
				  HighlightWidgetView(entry: entry)
				  .widgetURL(URL(string: "tinyreads://highlight?id=\(entry.highlight.id)"))
				}
		  }
		  .configurationDisplayName("Your selected Highlights")
		  .description("Your Highlight, from your reading")
	 }
}

#Preview(as: .systemSmall) {
  HighlightWidget()
} timeline: {
  HighlightEntry(date: .now, highlight: .preview)
}
