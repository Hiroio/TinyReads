//
//  HighlightView.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import SwiftUI

struct HighlightView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var viewModel: HighlightActionViewModel
  
  init(state: HighlightScreenState){
	 self._viewModel = State(wrappedValue: HighlightActionViewModel(highlight: state.value, state: state))
  }
  
    var body: some View {
		VStack{
		  HStack{
			 if viewModel.note{
				Button{
				  withAnimation{
					 viewModel.note = false
				  }
				}label:{
				  Image(systemName: "arrow.left")
					 .foregroundStyle(themeManager.themeAssets.accent)
					 .padding(10)
					 .background(
						Image(themeManager.themeAssets.backSmallCard)
						  .resizable()
					 )
				}
			 }
			 
			 Spacer()
			 
			 Button{
				NavigationManager.shared.highlight = nil
			 }label:{
				Image(systemName: "xmark")
				  .foregroundStyle(themeManager.themeAssets.accent)
				  .padding(10)
				  .background(
					 Image(themeManager.themeAssets.backSmallCard)
						.resizable()
				  )
			 }
		  }
			 .frame(maxWidth: .infinity)
		  
		  if viewModel.note {
			 HighlightNoteView(viewModel: viewModel)
				.transition(.move(edge: .trailing))
				.zIndex(1)
		  }else{
			 HighlightPreviewView(viewModel: viewModel)
				.transition(.move(edge: .leading))
				.zIndex(1)
		  }
		  
		  
		  
		  if !viewModel.actionBtnText.isEmpty {
			 if viewModel.state.value.note != viewModel.highlight.note{
				Text("Changed")
			 }else{
				actionBtn
			 }
		  }
		}
		.padding(.horizontal, 20)
		.animation(.easeInOut, value: viewModel.note)
    }
		
}

#Preview {
  HighlightView(state: .create(.preview))
	 .environment(ThemeManager())
}


extension HighlightView{
  private var actionBtn: some View {
	 HStack{
		Button{
		  
		}label:{
		  Text(viewModel.actionBtnText)
			 .accent(weight: .semibold)
			 .padding()
			 .background(
				Image(themeManager.themeAssets.readerCard)
				  .resizable()
				  .shadow(radius: 1)
			 )
		}
		.frame(maxWidth: .infinity)
	 }
  }
}
