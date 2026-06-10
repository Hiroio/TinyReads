//
//  ArticleBottomBar.swift
//  TinyReads
//
//  Created by user on 10.06.2026.
//

import SwiftUI

struct ArticleBottomBar: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(ArticleViewModel.self) var vm
  let scrollUp: Bool
  let onInteractionChanged: () -> ()
    var body: some View {
		Group{
		  if scrollUp{
			 HStack{
				Button{
				  if vm.markAsDismiss(){
					 onInteractionChanged()
				  }
				}label: {
				  VStack{
					 Image("DismissAction")
						.resizable()
						.scaledToFit()
						.frame(width: 65)
						.shadow(color: .red.opacity(0.9), radius: 1)
						.background(
						  Circle()
							 .fill(themeManager.themeAssets.card)
							 .shadow(color: .red, radius: vm.interactionState == .dismissed ? 1 : 0)
						)
					 Text("Dismiss")
						.foregroundStyle(.red)
						.secondary()
				  }
				}
				.disabled(vm.interactionState == .dismissed)
				.opacity(opacityForDismiss)
				Spacer()
				Button{
				  if vm.markAsRead(){
					 onInteractionChanged()
				  }
				}label: {
				  VStack{
					 Image("ReadAction")
						.resizable()
						.scaledToFit()
						.frame(width: 65)
						.shadow(color: .green.opacity(0.9), radius: 1)
						.background(
						  Circle()
							 .fill(themeManager.themeAssets.card)
							 .shadow(color: .green, radius: vm.interactionState == .read ? 1 : 0)
						)
					Text("Read")
						.foregroundStyle(.green)
						.secondary()
				  }
				  
				}
				.disabled(vm.interactionState == .read)
				.opacity(opacityForRead)
			 }
			 .padding(.horizontal)
			 .transition(.move(edge: .bottom).combined(with: .opacity))
			 .allowsHitTesting(scrollUp)
		  }
		}
    }
  
  var opacityForDismiss: CGFloat{
	 let readed = vm.interactionState == .read
	 let dismissed = vm.interactionState == .dismissed
	 return dismissed ? 1 : (readed ? 0.3 : 1)
  }
  
  var opacityForRead: CGFloat{
	 let readed = vm.interactionState == .read
	 let dismissed = vm.interactionState == .dismissed
	 return readed ? 1 : (dismissed ? 0.3 : 1)
  }
}

#Preview {
  ArticleBottomBar(scrollUp: true, onInteractionChanged: {})
	 .environment(ThemeManager())
	 .environment(ArticleViewModel(article: ArticleRoute(article: .getForPreview(), onInteractionChanged: {}, isAbleToInteract: .dismissed)))
}
