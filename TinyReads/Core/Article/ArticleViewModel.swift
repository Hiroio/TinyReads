//
//  ArticleViewModel.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import Foundation
import UIKit.UIPasteboard

@MainActor
@Observable
final class ArticleViewModel{
  var article: ReadCardModel
  var interactionState: ReadCardDisplayStatus
  var selectedText: String = ""
  
  private let coreData: CoreDataService
  
  init(article: ArticleRoute){
	 self.article = article.article
	 self.coreData = .shared
	 self.interactionState = article.isAbleToInteract
  }
  
  
  var articleSaved: Bool {
	 return interactionState == .archived || interactionState == .read
  }
  
  var shareText: String {
	 """
	 Tiny Read: \(article.title)

	 \(article.hook)

	 Short reads for curious minds.
	 """
  }
  
}




extension ArticleViewModel{
  func markAsRead() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 if self.coreData.markRead(interaction) {
		self.interactionState = .read
		AnalyticsManager.shared.readCard(card: article)
		showAnimation(.read)
		return true
	 }else{
		showAnimation(.error)
		return false
	 }
  }
  
  func markAsSaved() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 if self.coreData.markSaved(interaction) {
		self.interactionState = .archived
		showAnimation(.save)
		return true
	 }else{
		showAnimation(.error)
		return false
	 }
  }
  
  func markAsDismiss() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 
	 if self.coreData.markDismissed(interaction){
		self.interactionState = .dismissed
		showAnimation(.dismiss)
		return true
	 }else{
		showAnimation(.error)
		return false
	 }
  }
  
  func showAnimation(_ state: SmallPopUpEnum){
		NavigationManager.shared.popUpState = state
  }
  
}



extension ArticleViewModel{
  
  func copyText() -> () {
	 UIPasteboard.general.string = selectedText
	 selectedText = ""
  }
  
  
  func highlight() {
	 let highlight = HighlightModel(
		id: UUID(),
		text: self.selectedText,
		note: "",
		originalTitle: article.title,
		originalId: article.id,
		categoryId: article.categoryId,
		languageCode: article.languageCode,
		widgetIsActive: false,
		dateCreated: Date()
	 )
	 
	 NavigationManager.shared.highlight = .create(highlight)
	 selectedText = ""
  }
}
