//
//  HighlightsView.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import SwiftUI

struct HighlightsView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = HighlightViewModel()
    var body: some View {
		ZStack{
		  VStack{
			 HighlightGridHeader(vm: vm)
		
			 
			 HighlightsGrid(vm: vm)
			
		  }
		}
    }
}

#Preview {
    HighlightsView()
	 .environment(ThemeManager())
}

