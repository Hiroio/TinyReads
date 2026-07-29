//
//  HighlightViewModel.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import Foundation

@MainActor
@Observable
final class HighlightViewModel{
  var highlights: [HighlightModel] { highlightManager.highlights }
  
  var searchText: String = ""
  var widgetState: Bool = false
  var deleteState: Bool = false
  
  private let highlightManager = HighlightManager.shared
  
  init(){
	 
  }
}




extension HighlightViewModel{
   
}
