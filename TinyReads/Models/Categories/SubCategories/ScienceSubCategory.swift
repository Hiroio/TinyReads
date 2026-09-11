//
//  ScienceSubCategory.swift
//  TinyReads
//
//  Created by user on 05.09.2026.
//

import SwiftUI

enum ScienceSubCategory: String, ReadSubCategory {
  case scienceUniversal, physics, space, neuroscience
  
  var id: String { rawValue }
  
  //  Space keeps the "" suffix (like scienceUniversal) so its already-planned free content
  //  keeps the old standalone-category Firestore id format (space_en_...), unchanged by this merge.
  var idSuffix: String {
	 switch self {
	 case .scienceUniversal, .space: ""
	 case .physics: "_physics"
	 case .neuroscience: "_neuroscience"
	 }
  }
  
  var category: String {
	 switch self {
	 case .scienceUniversal, .physics,  .neuroscience: ReadCategories.science.rawValue
	 case .space: "space"
	 }
  }

  var parentCategory: ReadCategories { .science }


  var storeId: String? {
	 switch self {
	 case .scienceUniversal, .space: nil
	 case .physics: "com.hiroio.tinyreads.subcategory.science.physics"
	 case .neuroscience: "com.hiroio.tinyreads.subcategory.science.neuroscience"
	 }
  }
  
  var title: LocalizedStringKey {
	 switch self {
	 case .scienceUniversal: "Universal"
	 case .physics: "Physics"
	 case .space: "Space"
	 case .neuroscience: "Neuro Science"
	 }
  }
  
  var image: String {
	 switch self {
	 case .scienceUniversal: "Science"
	 case .physics: "Physics"
	 case .space: "Space"
	 case .neuroscience: "NeuroScience"
	 }
  }
  
  var count: Int {
	 switch self {
	 case .scienceUniversal: 200
	 case .physics: 80
	 case .space: 100
	 case .neuroscience: 80
	 }
  }
}
