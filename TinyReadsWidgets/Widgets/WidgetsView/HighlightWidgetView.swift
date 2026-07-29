//
//  HiglightWidgetView.swift
//  TinyReads
//
//  Created by user on 28.07.2026.
//

import SwiftUI
import WidgetKit

struct HighlightWidgetView: View {
  @Environment(\.widgetFamily) var widgetFamily
  @Environment(\.colorScheme) var colorScheme
  let entry: HighlightEntry
  var body: some View {
	 VStack(spacing: 15){
		
		
		Text(entry.highlight.text)
		  .font(font)
		  .foregroundStyle(colorScheme == .dark ? .accentD : .accentLight)
		
		
		if widgetFamily == .systemMedium {
		  Text(entry.highlight.originalTitle)
			 .font(.caption.weight(.light))
			 .foregroundStyle(colorScheme == .dark ? .accentD : .accentLight)
		}else if widgetFamily == .systemLarge{
		  Text(entry.highlight.originalTitle)
			 .font(.footnote.weight(.light))
			 .lineLimit(5)
			 .foregroundStyle(colorScheme == .dark ? .secondaryD : .secondaryLight)
		  Text(entry.highlight.categoryId)
			 .font(.caption.weight(.light))
			 .foregroundStyle(colorScheme == .dark ? .accentD : .accentLight)
		}
	 }
	 .fontDesign(.serif)
	 .multilineTextAlignment(.center)
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
	 return widgetFamily == .systemSmall ? .footnote.weight(.light) : widgetFamily == .systemMedium ? .title3.weight(.light) : .title2.weight(.light)
  }
}
