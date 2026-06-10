//
//  ArticleViewModel.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import Foundation


@Observable
final class ArticleViewModel{
  var article: ReadCardModel
  var interactionState: ReadCardDisplayStatus
  
  private let coreData: CoreDataService
  
  init(article: ArticleRoute){
	 self.article = article.article
	 self.coreData = .shared
	 self.interactionState = article.isAbleToInteract
  }
  
  
  func markAsRead() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 if self.coreData.markRead(interaction) {
		self.interactionState = .read
		return true
	 }else{
		return false
	 }
  }
  
  func markAsDismiss() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 
	 if self.coreData.markDismissed(interaction){
		self.interactionState = .dismissed
		return true
	 }else{
		return false
	 }
  }
}
