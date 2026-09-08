//
//  ReadsDeckManager.swift
//  TinyReads
//
//  Created by user on 04.06.2026.
//

import Foundation


extension Array where Element == ReadInteractionModel{
  func getNextSortIndex(per category: any ReadSubCategory) -> Int{
	 guard !self.isEmpty else { return 0 }
	 
		if let sortedIndex = self.filter({ $0.categoryId == category.category && $0.subCategoryId == category.id }).sorted(by: {$0.sortIndex > $1.sortIndex}).first?.sortIndex {
		  return sortedIndex + 1
		}else {
		  return 0
		}
	 }
}
