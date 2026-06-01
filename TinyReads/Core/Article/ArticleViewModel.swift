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
  
  
  init(article: ReadCardModel){
	 self.article = article
  }
}
