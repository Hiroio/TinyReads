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
		TimelineView(.animation(minimumInterval: 0.3)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let spriteIndex = (Int(elapsed / 0.3) % 5)
		 
		  Image("Loading\(spriteIndex)")
			 .resizable()
			 .scaledToFit()
		}
    }
}

#Preview {
    LoadingView()
}
