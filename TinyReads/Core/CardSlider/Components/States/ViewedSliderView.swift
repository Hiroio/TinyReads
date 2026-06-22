//
//  ViewedSliderView.swift
//  TinyReads
//
//  Created by user on 22.06.2026.
//

import SwiftUI

struct ViewedSliderView: View {
  @Environment(CardSliderViewModel.self) var vm
  var body: some View {
	 ZStack{
		let _ = vm.cards.count
		let cards = vm.repeatDisplayReads
		if cards.isEmpty{
		  CardEmptyState()
			 .transition(.move(edge: .bottom).combined(with: .opacity))
		}else{
		  SlideView(
			 readArray: vm.repeatDisplayReads,
			 onSave: vm.onSave,
			 onDismiss: vm.onDismiss,
			 onTap: vm.openArticle
		  )
		}
	 }
  }
}

#Preview {
  ViewedSliderView()
	 .environment(CardSliderViewModel())
}
