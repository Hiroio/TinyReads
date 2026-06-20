//
//  ArticleView.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import SwiftUI

struct ArticleView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var scrollUp: Bool = true
  @State private var vm: ArticleViewModel
  let onInteractionChanged: () -> ()
  init(article: ArticleRoute){
	 self._vm = State(wrappedValue: ArticleViewModel(article: article))
	 self.onInteractionChanged = article.onInteractionChanged
  }
  var body: some View {
	 ScrollView(){
		let article = vm.article
		VStack(spacing: 20){
		  VStack(spacing: 10){
			 Text(article.title)
				.title(weight: .bold)
			 Text(article.hook)
				.secondary()
		  }
		  .multilineTextAlignment(.center)
		  
		  Text(article.body)
			 .regular(weight: .medium)
			 .lineSpacing(7)
			 .padding(10)
		  
		  
		  VStack{
			 Text("Tags")
				.frame(maxWidth: .infinity, alignment: .leading)
				.font(.subheadline.weight(.semibold))
			 ScrollView(.horizontal, showsIndicators: false){
				HStack{
				  ForEach(article.tags, id: \.self){tag in
					 TagCard(tag)
				  }
				}
			 }
		  }.fontDesign(.serif)
		}
		.padding(35)
		.background(
		  PaperBackGround()
		)
	 }
	 .onScrollGeometryChange(for: CGFloat.self) { geometry in
		let offsetY = geometry.contentOffset.y
			 let maxOffsetY = max(0, geometry.contentSize.height - geometry.containerSize.height)
			 let minOffsetY = min (0, geometry.contentSize.height)
			 return min(max(offsetY, minOffsetY), maxOffsetY)
	 } action: { oldValue, newValue in
		let delta = newValue - oldValue
			 guard abs(delta) > 2 else { return }
		
		withAnimation {
			 if delta > 0 {
				  scrollUp = false
			 } else {
				  scrollUp = true
			 }
		}
	 }
	 .overlay(
		ArticleBottomBar(scrollUp: scrollUp, onInteractionChanged: onInteractionChanged)
		  .environment(vm),
		alignment: .bottom
	 )
	 .overlay(
		Group{
		  if scrollUp{
			 Button{
				withAnimation(){
				  NavigationManager.shared.article = nil
				}
			 }label:{
				Image(systemName: "xmark")
				  .font(.title2.weight(.medium))
				  .padding(15)
				  .foregroundStyle(themeManager.themeAssets.primary)
			 }
		  }
		},
		alignment: .topTrailing
	 )
	 .overlay {
		Group{
		  if let state = vm.showState {
			 CompletedAnimation(state: state)
				.padding(40)
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
					 .scaledToFill()
				)
		  }
		}
	 }
	 .animation(.easeInOut, value: vm.showState != nil)
  }
}

@ViewBuilder
func TagCard(_ tag: String) -> some View{
  Text(tag)
	 .padding(10)
	 .font(.caption.weight(.light))
	 .fontDesign(.serif)
}

#Preview {
  ArticleView(article: .init(article: .getForPreview(), onInteractionChanged: {}, isAbleToInteract: .read))
	 .environment(ThemeManager())
}
