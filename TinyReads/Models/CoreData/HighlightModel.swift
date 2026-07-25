//
//  HighlightModel.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import Foundation


struct HighlightModel: Codable, Identifiable, Equatable {
  let id: UUID
  var text: String
  var note: String
  
  let originalTitle: String
  let originalId: String
  
  let categoryId: String
  let languageCode: String
  
  var widgetIsActive: Bool
  var dateCreated: Date
}


extension HighlightModel{
  init(entity: HighlightEntity){
	 self.id = entity.id ?? UUID()
	 self.text = entity.text ?? ""
	 self.note = entity.note ?? ""
	 self.categoryId = entity.categoryId ?? ""
	 self.originalId = entity.originalId ?? ""
	 self.originalTitle = entity.originalTitle ?? ""
	 self.languageCode = entity.languageCode ?? ""
	 self.widgetIsActive = entity.widgetIsActive
	 self.dateCreated = entity.dateCreated ?? Date()
  }
  
  static var preview = HighlightModel(id: UUID(), text: "qweqweqw qwdkoqw okdkrei feij feiminiw ei ifenmf einknje infei mfei",note: "",originalTitle: "Some sort of title of original topic", originalId: "qwe", categoryId: "science", languageCode: "uk", widgetIsActive: false, dateCreated: .now)
  static func previewf() -> HighlightModel{HighlightModel(id: UUID(), text: "qweqweqw qwdkoqw okdkrei feij feiminiw ei ifenmf einknje infei mfei",note: "",originalTitle: "Some sort of title of original topic", originalId: "qwe", categoryId: "science", languageCode: "uk", widgetIsActive: false, dateCreated: .now)}
  
}
