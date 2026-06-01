//
//  FirestoreProtocol.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation

protocol PublicReadsServiceProtocol {
  func fetchReads(
    categoryIds: [String],
    languageCode: String,
    limit: Int
  ) async throws -> [ReadCardModel]
}
