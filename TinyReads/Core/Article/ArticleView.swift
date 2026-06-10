//
//  ArticleView.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import SwiftUI

struct ArticleView: View {
  @State private var scrollUp: Bool = true
  @State private var vm: ArticleViewModel
  let onInteractionChanged: () -> ()
  init(article: ArticleRoute){
	 self._vm = State(wrappedValue: ArticleViewModel(article: article.article))
	 self.onInteractionChanged = article.onInteractionChanged
  }
  var body: some View {
	 ScrollView(){
		let article = vm.article
		VStack(spacing: 20){
		  VStack(spacing: 10){
			 Text(article.title)
				.title()
			 Text(article.hook)
				.padding(.horizontal, 1)
				.secondary()
		  }
		  .multilineTextAlignment(.center)
		  
		  Text(article.body)
			 .font(.subheadline.weight(.medium))
			 .fontDesign(.serif)
			 .foregroundStyle(.primary.opacity(0.88))
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
			 return min(max(offsetY, 0), maxOffsetY)
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
		Group{
		  if scrollUp{
			 HStack{
				Button{
				  if vm.markAsDismiss(){
					 onInteractionChanged()
				  }
				}label: {
				  Image("DismissAction")
					 .resizable()
					 .scaledToFit()
					 .frame(width: 65)
					 .shadow(color: .red.opacity(0.8), radius: 3)
				}
				Spacer()
				Button{
				  if vm.markAsRead(){
					 onInteractionChanged()
				  }
				}label: {
				  Image("ReadAction")
					 .resizable()
					 .scaledToFit()
					 .frame(width: 65)
					 .shadow(color: .green.opacity(0.6), radius: 3)
				}
			 }
			 .padding(.horizontal)
			 .transition(.move(edge: .top).combined(with: .opacity))
			 .allowsHitTesting(scrollUp)
		  }
		},
		alignment: .top
	 )
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
  ArticleView(article: .init(article: .getForPreview(), onInteractionChanged: {}))
	 .environment(ThemeManager())
}
