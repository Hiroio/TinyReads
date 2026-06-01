//
//  AuthModels.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation

struct AuthUserModel: Equatable {
  let uid: String
  let isAnonymous: Bool
  let email: String?
  let displayName: String?
}

struct GoogleSignInResultModel {
  let idToken: String
  let accessToken: String
  let name: String?
  let email: String?
}

struct AppleSignInResultModel {
  let idToken: String
  let nonce: String
  let fullName: PersonNameComponents?
}

enum AuthServiceError: LocalizedError {
  case missingCurrentUser

  var errorDescription: String? {
	 switch self {
	 case .missingCurrentUser:
		return "No authenticated Firebase user was found."
	 }
  }
}
