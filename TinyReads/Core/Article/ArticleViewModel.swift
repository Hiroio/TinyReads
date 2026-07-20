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
  var showState: AnimationCompletionEnum? = nil
  var showConfirmation: Bool = false
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
		showAnimation(true)
		return true
	 }else{
		showAnimation(false)
		return false
	 }
  }
  
  func markAsSaved() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 if self.coreData.markSaved(interaction) {
		self.interactionState = .archived
		showAnimation(true)
		return true
	 }else{
		showAnimation(false)
		return false
	 }
  }
  
  func markAsDismiss() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 
	 if self.coreData.markDismissed(interaction){
		self.interactionState = .dismissed
		showAnimation(true)
		return true
	 }else{
		showAnimation(false)
		return false
	 }
  }
  
  func showAnimation(_ state: Bool){
	 if state{
		self.showState = .success
	 }else{
		self.showState = .failure
	 }
	 Task{
		try await Task.sleep(for: .seconds(state ? 1.1 : 1.7))
		self.showState = nil
	 }
  }
  
}



extension ArticleViewModel{
  
  func copyText() -> () {
	 UIPasteboard.general.string = selectedText
	 showConfirmation = true
  }
  
}
