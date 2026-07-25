//
//  SelectionMenuView.swift
//  TinyReads
//
//  Created by user on 18.07.2026.
//

import SwiftUI

struct SelectionMenuView: View {
  @Environment(ThemeManager.self) var themeManager
  @State private var isExpanded: Bool = false
  @Binding var selectedText: String
  let menuBtns: [String] = ["Copy", "Highlight"]
  
  let copy: () -> ()
  let highlight: () -> ()
    var body: some View {
		HStack{
		  Button{withAnimation{copy()}}label:{
				Text("Copy")
				.accent(weight: .ultraLight)
			 Divider()
				.frame(height: 35)
		  }
		  Button{
			 withAnimation {
				highlight()
			 }
		  }label:{
				Text("Highlight")
				.accent(weight: .ultraLight)
			 Divider()
				.frame(height: 35)
		  }
		  
		  if isExpanded{
			 ShareLink(item: selectedText, subject: Text("share selection with Tiny Reads"), message: Text("Tiny Reads - \(selectedText.prefix(10))")){
				Text("Share")
				  .accent(weight: .ultraLight)
				  .transition(.scale)
			 }
		  }
		  
		  Button{
			 withAnimation {
				isExpanded.toggle()
			 }
		  }label: {
			 Image(systemName: "chevron.right")
				.rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
				.foregroundStyle(themeManager.themeAssets.accent)
		  }
		}
		.compositingGroup()
		.frame(height: 55)
		.padding(.horizontal)
		.background(
		  Image(themeManager.themeAssets.readerCard)
			 .resizable()
		)
    }
}

#Preview {
  SelectionMenuView(selectedText: .constant(""), copy: {}, highlight: {})
	 .environment(ThemeManager())
}
