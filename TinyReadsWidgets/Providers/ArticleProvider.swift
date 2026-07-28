//
//  ArticleProvider.swift
//  TinyReads
//
//  Created by user on 28.07.2026.
//

import WidgetKit



struct ArticleProvider: TimelineProvider {
  func placeholder(in context: Context) -> ArticleEntry {
	 ArticleEntry(date: .now, article: .getForPreview())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (ArticleEntry) -> ()) {
	 let entry = ArticleEntry(date: .now, article: .getForPreview())
	 completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<ArticleEntry>) -> ()) {
	 let language: String = UserDefaults(suiteName: "group.com.hiroio.tinyreads")?.string(forKey: "selectedLanguage") ?? "en"
	 
	 Task{
		let categories: ReadCategories = .allCases.randomElement()!
		let sortIndex = Int.random(in: 0...100)
		let article = try? await FireStoreService.shared.fetchReads(categoryProgress: [categories.rawValue : sortIndex], languageCode: language, limitPerCategory: 1)
		var entry: ArticleEntry
		if let singleArticle = article?.first{
		  entry = ArticleEntry(date: .now, article: singleArticle)
		}else{
		  entry = ArticleEntry(date: .now, article: .getForPreview(language: language))
		}
		
		let updateTime = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
		let timeline = Timeline(entries: [entry], policy: .after(updateTime))
		completion(timeline)
	 }
	 
	 
	 
  }
  
  //    func relevances() async -> WidgetRelevances<Void> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}
