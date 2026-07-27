//
//  NotRoundCircle.swift
//  TinyReads
//
//  Created by user on 27.07.2026.
//

import Foundation
import SwiftUI

struct NotRoundCircle: Shape {
  // fixed radius wobble per point, kept static so the shape doesn't "flicker" on redraw
  private let jitter: [CGFloat] = [1.00, 0.97, 1.03, 0.98, 1.02, 0.96, 1.03, 0.99, 1.02, 0.98, 1.01, 1.00]
  private let startAngle: Double = -100
  private let totalSweep: Double = 375

  func path(in rect: CGRect) -> Path {
	 let center = CGPoint(x: rect.midX, y: rect.midY)
	 let radiusX = rect.width / 2
	 let radiusY = rect.height / 2

	 func point(_ i: Int) -> CGPoint {
		let t = Double(i) / Double(jitter.count - 1)
		let angle = (startAngle + t * totalSweep) * .pi / 180
		let wobble = jitter[i]
		return CGPoint(
		  x: center.x + radiusX * wobble * cos(angle),
		  y: center.y + radiusY * wobble * sin(angle)
		)
	 }

	 func midpoint(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
		CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
	 }

	 var path = Path()
	 path.move(to: point(0))
	 for i in 0..<(jitter.count - 1) {
		let current = point(i)
		let next = point(i + 1)
		path.addQuadCurve(to: midpoint(current, next), control: current)
	 }
	 path.addQuadCurve(to: point(jitter.count - 1), control: point(jitter.count - 1))

	 return path
  }
}

#Preview {
  NotRoundCircle()
	 .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
	 .frame(width: 250, height: 200)
	 .padding()
}
