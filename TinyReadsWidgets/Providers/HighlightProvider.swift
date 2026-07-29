//
//  ArticleProvider.swift
//  TinyReads
//
//  Created by user on 28.07.2026.
//

import WidgetKit



struct HighlightProvider: TimelineProvider {
  func placeholder(in context: Context) -> HighlightEntry {
	 HighlightEntry(date: .now, highlight: .preview)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (HighlightEntry) -> ()) {
	 let entry = HighlightEntry(date: .now, highlight: .preview)
	 completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<HighlightEntry>) -> ()) {
	 let highlightManager = HighlightManager.shared
	 highlightManager.syncHighlight()
	 
	 
	 var entries : [HighlightEntry] = []
	 if highlightManager.filteredForWidget.isEmpty{
		entries.append(HighlightEntry(date: .now, highlight: .noHighlight))
	 }else{
		var time = Date.now
		highlightManager.filteredForWidget.forEach { item in
		  entries.append(HighlightEntry(date: time, highlight: item))
		  time = Calendar.current.date(byAdding: .minute, value: 30, to: time)!
		}
	 }
	 
	 let updateTime = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
	 let timeline = Timeline(entries: entries, policy: .after(updateTime))
	 completion(timeline)
	 
	 
	 
  }
  
  //    func relevances() async -> WidgetRelevances<Void> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}
