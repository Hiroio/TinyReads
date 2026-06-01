//
//  MockFireStoreService.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation


class MockFireStoreService: PublicReadsServiceProtocol{
  func fetchReads(categoryIds: [String], languageCode: String, limit: Int) async throws -> [ReadCardModel] {
	 try uploadTestCards()
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
