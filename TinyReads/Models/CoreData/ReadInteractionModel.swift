//
//  ReadInteractionModel.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation

struct ReadInteractionModel: Identifiable, Codable {
	 let id: String
	 let categoryId: String
	 let languageCode: String
	 
	 // status
	 var isSaved: Bool
	 var isRead: Bool
	 var isLiked: Bool
	 var isSkipped: Bool
	 
	 
	 var savedAt: Date?
	 var readAt: Date?
	 var skippedAt: Date?
	 
	 var skipCount: Int
  
  
  init(id: String, categoryId: String, languageCode: String){
	 self.id = id
	 self.categoryId = categoryId
	 self.languageCode = languageCode
	 
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

		
		  self.isSaved = entity.isSaved
		  self.isRead = entity.isRead
		  self.isLiked = entity.isLiked
		  self.isSkipped = entity.isSkipped

		  self.savedAt = entity.savedAt
		  self.readAt = entity.readAt
		  self.skippedAt = entity.skippedAt

		  self.skipCount = Int(entity.skipCount)
	 }
}
