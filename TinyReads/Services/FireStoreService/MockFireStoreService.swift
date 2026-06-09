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
	        guard let nextSortIndex = categoryProgress[card.categoryId] else { return false }
			  let previousSortIndex = max(nextSortIndex - 1, 0)
			  
			  return card.languageCode == languageCode
				&& card.sortIndex > previousSortIndex
				&& card.sortIndex <= previousSortIndex + limitPerCategory
	      }
		      .sorted { $0.sortIndex < $1.sortIndex }
		  }
  
  func fetchReads(ids: [String]) async throws -> [ReadCardModel] {
	 let cards = try uploadTestCards()
	 let order = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($0.element, $0.offset) })
	 
	 return cards
		.filter { ids.contains($0.id) }
		.sorted {
		  (order[$0.id] ?? .max) < (order[$1.id] ?? .max)
		}
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
