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
			 
			 CustomSearchBar(searchText: $vm.searchText)
			 
			 Spacer()
			 HighlightsGrid(highlights: vm.highlights)
		  }
		}
    }
}

#Preview {
    HighlightsView()
	 .environment(ThemeManager())
}

