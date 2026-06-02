//
//  FirestoreProtocol.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation

protocol PublicReadsServiceProtocol {
  func fetchReads(
    categoryProgress: [String: Int],
    languageCode: String,
    limitPerCategory: Int
  ) async throws -> [ReadCardModel]
}
