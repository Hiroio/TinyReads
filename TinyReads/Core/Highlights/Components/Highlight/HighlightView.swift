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
	 ZStack{
		VStack{
//		  Header
		  HighlightHeaderView(noteIsActive: $viewModel.note){
			 withAnimation {
				viewModel.exitAction()
			 }
		  }
		  
//		  Two workSpaces
		  if viewModel.note {
			 HighlightNoteView(viewModel: viewModel)
				.transition(.move(edge: .trailing))
				.zIndex(1)
		  }else{
			 HighlightPreviewView(viewModel: viewModel)
				.transition(.move(edge: .leading))
				.zIndex(1)
		  }
		  
		  
//		  Bottom action
		  if viewModel.actionBtnText != nil {
			 actionBtn
		  }
		}
		.padding(.horizontal, 20)
		.animation(.easeInOut, value: viewModel.note)
	 }
	 if viewModel.warningText != ""{
		WarningPopUp(caption: $viewModel.warningText){
		  withAnimation {
			 NavigationManager.shared.highlight = nil
		  }
		}
	 }
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
		  viewModel.actionBtn()
		}label:{
		  Text(viewModel.actionBtnText?.actionBtn ?? "")
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
