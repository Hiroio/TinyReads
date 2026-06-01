//
//  CoreDataExtensions.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

extension ReadsEntity{
  func update(from read: ReadInteractionModel){
	 self.id = read.id
	 self.categoryId = read.categoryId
	 self.languageCode = read.languageCode
	 
	 self.isLiked = read.isLiked
	 self.isRead = read.isRead
	 self.isSaved = read.isSaved
	 self.isSkipped = read.isSkipped
	 
	 self.readAt = read.readAt
	 self.savedAt = read.savedAt
	 
	 self.skippedAt = read.skippedAt
	 self.skipCount = Int16(clamping: read.skipCount)
  }
}
