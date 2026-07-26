//
//  HighlightGridHeader.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import SwiftUI

struct HighlightGridHeader: View {
  @Bindable var vm: HighlightViewModel
  
    var body: some View {
		HStack{
		  Button{
			 NavigationManager.shared.secondary = nil
		  }label:{
			 Image(systemName: "xmark")
		  }
		  .buttonStyle(SmallBtnStyle())
		  
		  Spacer()
		  
		  Button{
			 
		  }label:{
			 Image(systemName: "star")
		  }
		  .buttonStyle(SmallBtnStyle())
		  
		  Button{
			 
		  }label:{
			 Image(systemName: "trash")
		  }
		  .buttonStyle(SmallBtnStyle())
		}
		.padding(.horizontal)
    }
}

#Preview {
  HighlightGridHeader(vm: HighlightViewModel())
}
