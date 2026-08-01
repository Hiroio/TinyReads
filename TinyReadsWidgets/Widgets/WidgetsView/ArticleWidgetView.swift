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
	 VStack(spacing: 15){
		
		
		Text(entry.article.title)
		  .font(font)
		  .foregroundStyle(.primary)
		
		
		if widgetFamily == .systemMedium {
		  Text(entry.article.categoryId)
			 .font(.footnote.weight(.light))
			 .foregroundStyle(colorScheme == .dark ? .accentD : .accentLight)
		}else if widgetFamily == .systemLarge{
		  Text(entry.article.hook)
			 .font(.caption.weight(.light))
			 .lineLimit(5)
			 .foregroundStyle(colorScheme == .dark ? .secondaryD : .secondaryLight)
		  
		  Text(entry.article.categoryId)
			 .font(.footnote.weight(.light))
			 .foregroundStyle(colorScheme == .dark ? .accentD : .accentLight)
			 .padding(.top)
		}
	 }
	 .fontDesign(.serif)
	 .multilineTextAlignment(widgetFamily == .systemSmall ? .leading : .center)
	 .padding()
	 .padding(.horizontal, widgetFamily != .systemSmall ? 15 : 0)
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .background(
		Image(backgroundImageName)
		  .resizable()
		  .shadow(radius: 2)
	 )
  }
  
  private var backgroundImageName: String {
	 let theme = colorScheme == .dark ? "Dark" : ""
	 let base = widgetFamily == .systemMedium ? "ReaderCard" : "SavedBackWidget"
	 return base + theme
  }
  
  private var font: Font{
	 return widgetFamily == .systemSmall ? .caption.weight(.light) : widgetFamily == .systemMedium ? .body.weight(.light) : .title2.weight(.light)
  }
}

#Preview {
  ArticleWidgetView(entry: ArticleEntry(date: .now, article: .getForPreview()))
}
