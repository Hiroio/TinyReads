//
//  AuthServiceErrorEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation

enum AuthServiceError: LocalizedError {
  case missingCurrentUser
  
  var errorDescription: String? {
	 switch self {
	 case .missingCurrentUser:
		return "No authenticated Firebase user was found."
	 }
  }
}
