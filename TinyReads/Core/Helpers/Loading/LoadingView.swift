//
//  LoadingView.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import SwiftUI

struct LoadingView: View {
  @State private var startTime = Date()
  var body: some View {
	 ZStack(alignment: .bottom){
		TimelineView(.animation(minimumInterval: 0.2)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let spriteIndex = (Int(elapsed / 0.2) % 10)
		  
		  VStack{
			 Image("Loading\(spriteIndex)")
				.resizable()
				.scaledToFit()
				.frame(width: 100)
			 
			 Text("Tiny Reads")
				.title()
		  }
		}
		
	 }
  }
}

#Preview {
    LoadingView()
	 .environment(ThemeManager())
}
