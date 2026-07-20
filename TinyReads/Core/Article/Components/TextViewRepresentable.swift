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

  @Binding var selectionRect: CGRect?
  @Binding var selectedText: String

  func makeUIView(context: Context) -> UITextView {
	 let view = ReaderTextView()
	 view.delegate = context.coordinator
	 view.backgroundColor = .clear
	 view.isEditable = false
	 view.isSelectable = true
	 view.isScrollEnabled = false
	 view.textContainerInset = .zero
	 view.textContainer.lineFragmentPadding = 0
	 view.attributedText = Self.makeAttributedText(text: text, color: textColor)

	 return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
	 if uiView.text != text {
		uiView.attributedText = Self.makeAttributedText(text: text, color: textColor)
	 }
  }

  func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
	 guard let width = proposal.width else { return nil }
	 return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
  }

  private static func makeAttributedText(text: String, color: Color) -> NSAttributedString {
	 let baseFont = UIFont.systemFont(ofSize: 17, weight: .medium)
	 let serifDescriptor = baseFont.fontDescriptor.withDesign(.serif) ?? baseFont.fontDescriptor
	 let font = UIFontMetrics(forTextStyle: .body)
		.scaledFont(for: UIFont(descriptor: serifDescriptor, size: 17))

	 let paragraphStyle = NSMutableParagraphStyle()
	 paragraphStyle.lineSpacing = 7

	 return NSAttributedString(string: text, attributes: [
		.font: font,
		.foregroundColor: UIColor(color),
		.paragraphStyle: paragraphStyle
	 ])
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
		  self.parent.selectionRect = nil
		  self.parent.selectedText = ""
		  return
		}
		
		let rect = textView.firstRect(for: range)
		self.parent.selectionRect = rect
		self.parent.selectedText = textView.text(in: range) ?? ""
	 }
	 
	 
	 
  }
  
  
}


final class ReaderTextView: UITextView {

	 override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		  false
	 }

	 override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
		  nil
	 }
}
