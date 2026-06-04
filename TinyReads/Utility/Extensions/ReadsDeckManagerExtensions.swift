//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 04.06.2026.
//

import Foundation


extension Array where Element == ReadInteractionModel{
  func getMaxSortIndex(per category: String) -> Int{
	 guard !self.isEmpty else { return 0 }
	 
	 return self.filter({$0.categoryId == category}).sorted(by: {$0.sortIndex > $1.sortIndex}).first?.sortIndex ?? 0
  }
}
