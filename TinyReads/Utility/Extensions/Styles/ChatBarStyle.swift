//
//  ChatBarStyle.swift
//  TinyReads
//
//  Created by user on 01.07.2026.
//

import Foundation
import SwiftUI


struct ChatTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
		.padding()
		.padding(.leading)
		.overlay(alignment: .bottom) {
		  HStack(spacing: 0){
			Image(systemName: "pencil")
				.font(.title2.weight(.light))
				.scaleEffect(x: -1)
				.offset(y: -10)
			 TextFieldLine()
				.stroke(lineWidth: 1)
				.frame(maxWidth: .infinity)
				.frame(height: 1)
		  }
		}
  }
}



extension View{
  func chatTextFieldStyle()-> some View{
	 textFieldStyle(ChatTextFieldStyle())
  }
}
