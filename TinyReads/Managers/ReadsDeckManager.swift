//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation


@Observable
class ReadsDeckManager{
  static let shared = ReadsDeckManager()
  
  var reads: [ReadsDeckManager] = []
  
  let firestore: PublicReadsServiceProtocol
  
  
  init(firestore: PublicReadsServiceProtocol = FireStoreService.shared) {
	 self.firestore = firestore
  }
  
  
}
