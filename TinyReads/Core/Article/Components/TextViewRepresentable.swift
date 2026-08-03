//
//  TextViewRepresentable.swift
//  TinyReads
//
//  Created by user on 18.07.2026.
//

import Foundation
import SwiftUI
import UIKit



struct TextViewRepresantable: UIViewRepresentable{
  let text: String
  let textColor: Color
  let highlightColor: Color
  let textToHighlight: [HighlightModel]

  @Binding var selectionRect: CGRect?
  @Binding var selectedText: String
  @Binding var selectedHighlight: HighlightModel?

  func makeUIView(context: Context) -> ReaderTextView {
	 let view = ReaderTextView()
	 view.delegate = context.coordinator
	 view.backgroundColor = .clear
	 view.isEditable = false
	 view.isSelectable = true
	 view.isScrollEnabled = false
	 view.textContainerInset = .zero
	 view.textContainer.lineFragmentPadding = 0

	 let (attributedText, ranges) = Self.makeAttributedText(text: text, color: textColor, highlightColor: highlightColor, highlights: textToHighlight)
	 view.attributedText = attributedText
	 view.highlightRanges = ranges
	 view.appliedHighlights = textToHighlight
	 view.onHighlightTap = { [coordinator = context.coordinator] highlight in
		DispatchQueue.main.async {
		  coordinator.parent.selectedHighlight = highlight
		  coordinator.parent.selectedText = ""
		  coordinator.parent.selectionRect = nil
		}
	 }

	 return view
  }

  func updateUIView(_ uiView: ReaderTextView, context: Context) {
	 if uiView.text != text || uiView.appliedHighlights != textToHighlight {
		let (attributedText, ranges) = Self.makeAttributedText(text: text, color: textColor, highlightColor: highlightColor, highlights: textToHighlight)
		uiView.attributedText = attributedText
		uiView.highlightRanges = ranges
		uiView.appliedHighlights = textToHighlight
	 }

	 if selectedText.isEmpty {
		if uiView.selectedTextRange != nil {
		  uiView.selectedTextRange = nil
		}
	 }
  }

  func sizeThatFits(_ proposal: ProposedViewSize, uiView: ReaderTextView, context: Context) -> CGSize? {
	 guard let width = proposal.width else { return nil }
	 return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
  }

  private static func makeAttributedText(
	 text: String,
	 color: Color,
	 highlightColor: Color,
	 highlights: [HighlightModel]
  ) -> (NSAttributedString, [(range: NSRange, highlight: HighlightModel)]) {
	 let baseFont = UIFont.systemFont(ofSize: 17, weight: .medium)
	 let serifDescriptor = baseFont.fontDescriptor.withDesign(.serif) ?? baseFont.fontDescriptor
	 let font = UIFontMetrics(forTextStyle: .body)
		.scaledFont(for: UIFont(descriptor: serifDescriptor, size: 17))

	 let paragraphStyle = NSMutableParagraphStyle()
	 paragraphStyle.lineSpacing = 7

	 let attributedText = NSMutableAttributedString(string: text, attributes: [
		.font: font,
		.foregroundColor: UIColor(color),
		.paragraphStyle: paragraphStyle
	 ])

	 var ranges: [(range: NSRange, highlight: HighlightModel)] = []
	 let highlightUIColor = UIColor(highlightColor)

	 for highlight in highlights {
		guard !highlight.text.isEmpty, let swiftRange = text.range(of: highlight.text) else { continue }
		let nsRange = NSRange(swiftRange, in: text)
		attributedText.addAttribute(.backgroundColor, value: highlightUIColor, range: nsRange)
		ranges.append((nsRange, highlight))
	 }

	 return (attributedText, ranges)
  }

  func makeCoordinator() -> TextCoordinator {
	 return TextCoordinator(parent: self)
  }


}

extension TextViewRepresantable{
  class TextCoordinator: NSObject, UITextViewDelegate{
	 let parent: TextViewRepresantable

	 init(parent: TextViewRepresantable){
		self.parent = parent
		super.init()
	 }


	 func textViewDidChangeSelection(_ textView: UITextView){
		guard let range = textView.selectedTextRange else {
		  DispatchQueue.main.async {
			 self.parent.selectionRect = nil
			 self.parent.selectedText = ""
		  }
		  return
		}

		let rect = textView.firstRect(for: range)
		let text = textView.text(in: range) ?? ""
		DispatchQueue.main.async {
		  self.parent.selectionRect = rect
		  self.parent.selectedText = text
		}
	 }



  }


}


final class ReaderTextView: UITextView {
  var highlightRanges: [(range: NSRange, highlight: HighlightModel)] = []
  var appliedHighlights: [HighlightModel] = []
  var onHighlightTap: ((HighlightModel?) -> Void)?

  private lazy var highlightTapGesture: UITapGestureRecognizer = {
	 UITapGestureRecognizer(target: self, action: #selector(handleHighlightTap(_:)))
  }()

  override init(frame: CGRect, textContainer: NSTextContainer?) {
	 super.init(frame: frame, textContainer: textContainer)
	 setupHighlightTapGesture()
  }

  required init?(coder: NSCoder) {
	 super.init(coder: coder)
	 setupHighlightTapGesture()
  }

  private func setupHighlightTapGesture() {
	 addGestureRecognizer(highlightTapGesture)
	 // Make sure our tap doesn't fire ahead of UITextView's own double-tap (word selection).
	 for recognizer in gestureRecognizers ?? [] {
		if let doubleTap = recognizer as? UITapGestureRecognizer, doubleTap !== highlightTapGesture, doubleTap.numberOfTapsRequired > 1 {
		  highlightTapGesture.require(toFail: doubleTap)
		}
	 }
  }

  @objc private func handleHighlightTap(_ gesture: UITapGestureRecognizer) {
	 guard textStorage.length > 0 else {
		onHighlightTap?(nil)
		return
	 }

	 let point = gesture.location(in: self)

	 let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
	 guard index < textStorage.length else {
		onHighlightTap?(nil)
		return
	 }

	 let match = highlightRanges.first(where: { NSLocationInRange(index, $0.range) })
	 onHighlightTap?(match?.highlight)
  }

	 override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		  false
	 }

	 override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
		  nil
	 }
}
