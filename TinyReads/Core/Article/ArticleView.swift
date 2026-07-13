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
				.padding()
				.textSelection(.enabled)
			 Text(article.hook)
				.secondary()
				.textSelection(.enabled)
		  }
		  .multilineTextAlignment(.center)
		  
		  Text(article.body)
			 .regular(weight: .medium)
			 .lineSpacing(7)
			 .textSelection(.enabled)
		  
		  
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
		.padding(.horizontal, UIDevice.isIPad ? 50 : 10)
		.padding(UIDevice.isIPad ? 75 : 40)
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
			 HStack(spacing: 5){
				Button{
				  if vm.markAsSaved(){
					 onInteractionChanged()
				  }
				}label:{
				  Image(vm.articleSaved ? "SaveAction" : themeManager.themeAssets.saveAction)
					 .resizable()
					 .scaledToFit()
					 .shadow(color: .green.opacity(0.7),radius: vm.articleSaved ? 3 : 0)
					 .padding(10)
					 .background(
						Image(themeManager.themeAssets.backSmallCard)
						  .resizable()
					 )
				}
				Spacer()
				
				Button{
				  withAnimation(){
					 NavigationManager.shared.article = nil
				  }
				}label:{
				  Image(systemName: "xmark")
					 .resizable()
					 .scaledToFit()
					 .padding(20)
					 .foregroundStyle(themeManager.themeAssets.primary)
					 .background(
						Image(themeManager.themeAssets.backSmallCard)
						  .resizable()
					 )
				}
			 }
			 .padding(.horizontal)
			 .frame(height: 55)
			 .compositingGroup()
			 .shadow(radius: 2)
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
