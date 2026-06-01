//
//  ArticleView.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import SwiftUI

struct ArticleView: View {
  @State private var vm: ArticleViewModel
  
  init(article: ReadCardModel){
	 self._vm = State(wrappedValue: ArticleViewModel(article: article))
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
  ArticleView(article: .getForPreview())
}
