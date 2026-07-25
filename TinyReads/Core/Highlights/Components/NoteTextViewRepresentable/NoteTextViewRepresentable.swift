//
//  NoteTextViewRepresentable.swift
//  TinyReads
//
//  Created by user on 25.07.2026.
//

import Foundation
import SwiftUI


struct NoteTextViewRepresentable: UIViewRepresentable {
  @Binding var text: String
  let textColor: Color
  let lineColor: Color

  private static let font = UIFont.systemFont(ofSize: 15)
  private static let extraLineSpacing: CGFloat = 10

  func makeUIView(context: Context) -> RuledTextView {
	 let view = RuledTextView()
	 view.delegate = context.coordinator
	 view.isEditable = true
	 view.isSelectable = true
	 view.isScrollEnabled = true
	 view.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
	 view.textContainer.lineFragmentPadding = 0
	 view.backgroundColor = .clear

	 view.typingAttributes = Self.attributes(color: textColor)
	 view.attributedText = Self.makeAttributedText(text: text, color: textColor)

	 view.baseLineHeight = Self.font.lineHeight
	 view.extraSpacing = Self.extraLineSpacing
	 view.lineColor = UIColor(lineColor).withAlphaComponent(0.4)

	 return view
  }

  func updateUIView(_ uiView: RuledTextView, context: Context) {
	 if uiView.text != text {
		let selectedRange = uiView.selectedRange
		uiView.attributedText = Self.makeAttributedText(text: text, color: textColor)
		uiView.selectedRange = selectedRange
	 }
	 uiView.typingAttributes = Self.attributes(color: textColor)
	 uiView.lineColor = UIColor(lineColor).withAlphaComponent(0.4)
	 uiView.setNeedsLayout()
  }

  private static func paragraphStyle() -> NSMutableParagraphStyle {
	 let style = NSMutableParagraphStyle()
	 style.lineSpacing = extraLineSpacing
	 return style
  }

  private static func attributes(color: Color) -> [NSAttributedString.Key: Any] {
	 [
		.font: font,
		.foregroundColor: UIColor(color),
		.paragraphStyle: paragraphStyle()
	 ]
  }

  private static func makeAttributedText(text: String, color: Color) -> NSAttributedString {
	 NSAttributedString(string: text, attributes: attributes(color: color))
  }

  func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

  final class Coordinator: NSObject, UITextViewDelegate {
	 let parent: NoteTextViewRepresentable
	 init(parent: NoteTextViewRepresentable) { self.parent = parent }

	 func textViewDidChange(_ textView: UITextView) {
		parent.text = textView.text
	 }
  }
}

final class RuledTextView: UITextView {
  private let linesLayer = CAShapeLayer()

  var baseLineHeight: CGFloat = 0 {
	 didSet { setNeedsLayout() }
  }

  var extraSpacing: CGFloat = 0 {
	 didSet { setNeedsLayout() }
  }

  var lineColor: UIColor = .clear {
	 didSet { linesLayer.strokeColor = lineColor.cgColor }
  }

  override init(frame: CGRect, textContainer: NSTextContainer?) {
	 super.init(frame: frame, textContainer: textContainer)
	 setup()
  }

  required init?(coder: NSCoder) {
	 super.init(coder: coder)
	 setup()
  }

  private func setup() {
	 linesLayer.lineWidth = 1
	 linesLayer.fillColor = UIColor.clear.cgColor
	 layer.insertSublayer(linesLayer, at: 0)
  }

  override func layoutSubviews() {
	 super.layoutSubviews()
	 redrawLines()
  }

  private func redrawLines() {
	 guard baseLineHeight > 0 else { return }

	 let width = bounds.width
	 let contentHeight = max(contentSize.height, bounds.height)
	 let step = baseLineHeight + extraSpacing

	 let path = UIBezierPath()
	 var y = textContainerInset.top + baseLineHeight
	 while y < contentHeight {
		path.move(to: CGPoint(x: 0, y: y.rounded(.down) + 0.5))
		path.addLine(to: CGPoint(x: width, y: y.rounded(.down) + 0.5))
		y += step
	 }

	 linesLayer.path = path.cgPath
	 linesLayer.frame = CGRect(x: 0, y: 0, width: width, height: contentHeight)
  }
}
