//
//  CardSliderView.swift
//  TinyReads
//
//  Created by user on 29.05.2026.
//

import SwiftUI

struct CardSliderView: View {
  @State private var vm = CardSliderViewModel()
  let color: AppThemeAssets
    var body: some View {
		ZStack{
		  color.background.ignoresSafeArea()
		  VStack{
			 if let error = vm.errorState{
				switch error {
				case .notFound:
				  VStack{
					 Text("Someting went wrong")
						.title()
					 
					 Image("NotFound")
						.resizable()
						.scaledToFit()
				  }
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
				  .background(
					 RoundedRectangle(cornerRadius: 5)
						.fill(color.card)
				  )
				case .notReady:
				  VStack{
					 Text("The card preparing")
						.title()
					 
					 Image("Test")
						.resizable()
						.scaledToFit()
				  }
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
				  .background(
					 RoundedRectangle(cornerRadius: 5)
						.fill(color.card)
				  )
				}
			 }else{
				VStack{
				  SlideView()
					 .environment(vm)
				}
			 }
		  }
		  .padding()
		}
    }
}

#Preview {
  CardSliderView(color: .light)
}
