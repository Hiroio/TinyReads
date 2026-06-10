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
  
  private let coreData: CoreDataService
  
  init(article: ReadCardModel){
	 self.article = article
	 self.coreData = .shared
  }
  
  
  func markAsRead() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 return self.coreData.markRead(interaction)
  }
  
  func markAsDismiss() -> Bool{
	 let interaction = ReadInteractionModel(readCard: article)
	 
	 return self.coreData.markDismissed(interaction)
  }
}
