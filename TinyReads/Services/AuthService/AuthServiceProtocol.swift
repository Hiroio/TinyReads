//
//  AuthServiceProtocol.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation

protocol AuthServiceProtocol {
  var currentUser: AuthUserModel? { get }
  var currentUserId: String? { get }
  var isSignedIn: Bool { get }
  var isAnonymous: Bool { get }

  @discardableResult
  func getAuthenticatedUser() throws -> AuthUserModel

  @discardableResult
  func ensureAnonymousUser() async throws -> AuthUserModel

  @discardableResult
  func signInAnonymously() async throws -> AuthUserModel

  @discardableResult
  func signIn(email: String, password: String) async throws -> AuthUserModel

  @discardableResult
  func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthUserModel

  @discardableResult
  func signInWithApple(tokens: AppleSignInResultModel) async throws -> AuthUserModel

  @discardableResult
  func linkWithEmail(email: String, password: String) async throws -> AuthUserModel

  @discardableResult
  func linkWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthUserModel

  @discardableResult
  func linkWithApple(tokens: AppleSignInResultModel) async throws -> AuthUserModel

  func signOut() throws
  func deleteCurrentUser() async throws
}
