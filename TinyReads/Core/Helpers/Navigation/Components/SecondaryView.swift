//
//  SecondaryView.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import SwiftUI

struct SecondaryView: View {
  @Environment(NavigationManager.self) var navigationManager
    var body: some View {
		ZStack{
		  switch navigationManager.secondary{
		  case .profile:
			 ProfileView()
		  case .category:
				CategoriesView(secondary: true)
		  default:
			 EmptyView()
		  }
		}
		.animation(.easeInOut, value: navigationManager.secondary != nil)
		.animation(.easeInOut, value: navigationManager.secondary == .profile)
    }
}

#Preview {
    SecondaryView()
	 .environment(NavigationManager.shared)
	 .environment(ThemeManager())
}
