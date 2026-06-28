//
//  CompletedAnimation.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import SwiftUI

struct CompletedAnimation: View {
  @State private var startTime = Date()
  @State private var pause: Bool = false
  let state: AnimationCompletionEnum
    var body: some View {
		TimelineView(.animation(minimumInterval: 0.05, paused: pause)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let spriteIndex = (Int(elapsed / 0.05))
		  let isFinished = spriteIndex >= state.sprites
		  VStack{
			 Image("\(state.name)\(min(state.sprites, spriteIndex))")
				.resizable()
				.scaledToFit()
				.frame(width: 100)
				.shadow(color: .green.opacity(0.4), radius: isFinished ? 10 : 0)
		  }
		  .onChange(of: spriteIndex, { oldValue, newValue in
			 if newValue >= state.sprites {
				self.pause = true
			 }
		  })
		  .animation(.easeInOut, value: isFinished)
		  .animation(.easeInOut(duration: 0.05), value: elapsed)
		}
		
    }
}

#Preview {
  CompletedAnimation(state: .success)
}
