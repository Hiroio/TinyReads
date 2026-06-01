//
//  FirebaseAuthService.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService: AuthServiceProtocol {
  static let shared = FirebaseAuthService()
  
  private let auth: Auth

  init(auth: Auth = Auth.auth()) {
	 self.auth = auth
  }

  var currentUser: AuthUserModel? {
	 auth.currentUser?.asAuthUserModel
  }

  var currentUserId: String? {
	 auth.currentUser?.uid
  }

  var isSignedIn: Bool {
	 auth.currentUser != nil
  }

  var isAnonymous: Bool {
	 auth.currentUser?.isAnonymous ?? false
  }

  @discardableResult
  func getAuthenticatedUser() throws -> AuthUserModel {
	 guard let user = auth.currentUser else {
		throw AuthServiceError.missingCurrentUser
	 }

	 return user.asAuthUserModel
  }

  @discardableResult
  func ensureAnonymousUser() async throws -> AuthUserModel {
	 if let user = auth.currentUser {
		return user.asAuthUserModel
	 }

	 return try await signInAnonymously()
  }

  func signOut() throws {
	 try auth.signOut()
  }

  func deleteCurrentUser() async throws {
	 guard let user = auth.currentUser else {
		throw AuthServiceError.missingCurrentUser
	 }

	 try await user.delete()
  }
}

// MARK: - Sign In

extension FirebaseAuthService {
  @discardableResult
  func signInAnonymously() async throws -> AuthUserModel {
	 let result = try await auth.signInAnonymously()
	 return result.user.asAuthUserModel
  }

  @discardableResult
  func signIn(email: String, password: String) async throws -> AuthUserModel {
	 let result = try await auth.signIn(withEmail: email, password: password)
	 return result.user.asAuthUserModel
  }

  @discardableResult
  func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthUserModel {
	 let credential = GoogleAuthProvider.credential(
		withIDToken: tokens.idToken,
		accessToken: tokens.accessToken
	 )

	 return try await signIn(with: credential)
  }

  @discardableResult
  func signInWithApple(tokens: AppleSignInResultModel) async throws -> AuthUserModel {
	 let credential = OAuthProvider.appleCredential(
		withIDToken: tokens.idToken,
		rawNonce: tokens.nonce,
		fullName: tokens.fullName
	 )

	 return try await signIn(with: credential)
  }

  private func signIn(with credential: AuthCredential) async throws -> AuthUserModel {
	 let result = try await auth.signIn(with: credential)
	 return result.user.asAuthUserModel
  }
}

// MARK: - Link Current User

extension FirebaseAuthService {
  @discardableResult
  func linkWithEmail(email: String, password: String) async throws -> AuthUserModel {
	 let credential = EmailAuthProvider.credential(
		withEmail: email,
		password: password
	 )

	 return try await link(with: credential)
  }

  @discardableResult
  func linkWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthUserModel {
	 let credential = GoogleAuthProvider.credential(
		withIDToken: tokens.idToken,
		accessToken: tokens.accessToken
	 )

	 return try await link(with: credential)
  }

  @discardableResult
  func linkWithApple(tokens: AppleSignInResultModel) async throws -> AuthUserModel {
	 let credential = OAuthProvider.appleCredential(
		withIDToken: tokens.idToken,
		rawNonce: tokens.nonce,
		fullName: tokens.fullName
	 )

	 return try await link(with: credential)
  }

  private func link(with credential: AuthCredential) async throws -> AuthUserModel {
	 guard let user = auth.currentUser else {
		throw AuthServiceError.missingCurrentUser
	 }

	 let result = try await user.link(with: credential)
	 return result.user.asAuthUserModel
  }
}

private extension User {
  var asAuthUserModel: AuthUserModel {
	 AuthUserModel(
		uid: uid,
		isAnonymous: isAnonymous,
		email: email,
		displayName: displayName
	 )
  }
}
