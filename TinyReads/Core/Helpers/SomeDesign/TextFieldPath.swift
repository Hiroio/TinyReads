//
//  TextFieldPath.swift
//  TinyReads
//
//  Created by user on 01.07.2026.
//

import SwiftUI

struct TextFieldLine: Shape {
	 func path(in rect: CGRect) -> Path {
		let quarterX = rect.midX / 2
		let moreThanHalf = rect.midX + quarterX
		  var path = Path()
		  path.move(to: CGPoint(x: rect.minX, y: rect.minY))
		  path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addCurve(to: CGPoint(x: moreThanHalf, y: rect.minY), control1: CGPoint(x: moreThanHalf - 10, y: rect.minY - 10), control2: CGPoint(x: rect.midX, y: rect.minY + 30))
		path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 30), control1: CGPoint(x: rect.maxX, y: rect.minY - 15), control2: CGPoint(x: rect.maxX, y: rect.minY + 30))
		  return path
	 }
}
