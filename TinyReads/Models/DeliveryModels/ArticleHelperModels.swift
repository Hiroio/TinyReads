//
//  ArticleRoute.swift
//  TinyReads
//
//  Created by user on 10.06.2026.
//

import Foundation

struct ArticleRoute {
  let article: ReadCardModel
  let onInteractionChanged: () -> Void
  var isAbleToInteract: ReadCardDisplayStatus = .fresh
}

