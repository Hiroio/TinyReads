//
//  ReadInteractionModelErrorEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation

enum ReadInteractionModelError: Error {
  case missingId
  case missingCategoryId
  case missingLanguageCode
}
