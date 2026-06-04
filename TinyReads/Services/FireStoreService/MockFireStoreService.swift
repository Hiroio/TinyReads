//
//  MockFireStoreService.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation


class MockFireStoreService: PublicReadsServiceProtocol{
  func fetchReads(
    categoryProgress: [String: Int],
    languageCode: String,
    limitPerCategory: Int
  ) async throws -> [ReadCardModel] {
		 try uploadTestCards()
      .filter { card in
        guard let lastSortIndex = categoryProgress[card.categoryId] else { return false }
		  
		  return card.languageCode == languageCode && card.sortIndex > lastSortIndex && card.sortIndex < (lastSortIndex + 1) + limitPerCategory
      }
      .sorted { $0.sortIndex < $1.sortIndex }
  }
  
  
  
  private func uploadTestCards() throws -> [ReadCardModel]{
	 guard let url = Bundle.main.url(forResource: "Ukraine_Philosophy", withExtension: "json") else {
		throw URLError(.badURL)
	 }
	 
	 let data = try Data(contentsOf: url)
	 let decodedData = try JSONDecoder().decode(RootReads.self, from: data)
	 return decodedData.reads
  }
}
