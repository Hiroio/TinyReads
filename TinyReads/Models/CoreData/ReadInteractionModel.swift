//
//  ReadInteractionModel.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

struct ReadInteractionModel: Identifiable, Codable {
  var id: String
  let categoryId: String
  let languageCode: String
  let sortIndex: Int
  
  // status
  var isSaved: Bool
  var isRead: Bool
  var isLiked: Bool
  var isSkipped: Bool
  
  
  var savedAt: Date?
  var readAt: Date?
  var skippedAt: Date?
  
  var skipCount: Int
  
  
  init(id: String, categoryId: String, languageCode: String, sortIndex: Int){
	 self.id = id
	 self.categoryId = categoryId
	 self.languageCode = languageCode
	 self.sortIndex = sortIndex
	 
	 
	 self.isSaved = false
	 self.isRead = false
	 self.isLiked = false
	 self.isSkipped = false
	 
	 self.savedAt = nil
	 self.readAt = nil
	 self.skippedAt = nil
	 
	 self.skipCount = 0
  }
}



// Mistakes if needed
enum ReadInteractionModelError: Error {
  case missingId
  case missingCategoryId
  case missingLanguageCode
}


// Mapper for coreData.
extension ReadInteractionModel {
  init(entity: ReadsEntity) throws {
	 guard let id = entity.id else {
		throw ReadInteractionModelError.missingId
	 }
	 
	 guard let categoryId = entity.categoryId else {
		throw ReadInteractionModelError.missingCategoryId
	 }
	 
	 guard let languageCode = entity.languageCode else {
		throw ReadInteractionModelError.missingLanguageCode
	 }
	 
	 self.id = id
	 self.categoryId = categoryId
	 self.languageCode = languageCode
	 self.sortIndex = Int(entity.sortIndex)
	 
	 self.isSaved = entity.isSaved
	 self.isRead = entity.isRead
	 self.isLiked = entity.isLiked
	 self.isSkipped = entity.isSkipped
	 
	 self.savedAt = entity.savedAt
	 self.readAt = entity.readAt
	 self.skippedAt = entity.skippedAt
	 
	 self.skipCount = Int(entity.skipCount)
  }
  
  
  init(readCard: ReadCardModel){
	 self.id = readCard.id
	 self.categoryId = readCard.categoryId
	 self.languageCode = readCard.languageCode
	 self.sortIndex = readCard.sortIndex
	 
	 
	 self.isSaved = false
	 self.isRead = false
	 self.isLiked = false
	 self.isSkipped = false
	 
	 self.savedAt = nil
	 self.readAt = nil
	 self.skippedAt = nil
	 
	 self.skipCount = 0
  }
}
