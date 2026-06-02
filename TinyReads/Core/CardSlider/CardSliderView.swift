//
//  CardSliderView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardSliderView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var vm = CardSliderViewModel()
  let color: AppThemeAssets
    var body: some View {
		ZStack{
		  color.background.ignoresSafeArea()
		  VStack{
			 if vm.loading{
				LoadingView()
			 }else{
				if let error = vm.errorState{
				  CardErrorHandlingView(error: error) {
					 vm.fetchCards()
				  }
				}else{
				  VStack{
					 SlideView()
						.environment(vm)
				  }
				}
			 }
		  }
		  .padding()
		}
    }
}

#Preview {
  CardSliderView(color: .light)
	 .environment(ThemeManager())
}
