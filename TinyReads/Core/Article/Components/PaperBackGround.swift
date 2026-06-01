//
//  PaperBackGround.swift
//  TinyReads
//
//  Created by user on 30.05.2026.
//

import SwiftUI

struct PaperBackGround: View {
	 private let assetWidth: CGFloat = 1051
	 private let topAssetHeight: CGFloat = 310
	 private let middleAssetHeight: CGFloat = 420
	 private let bottomAssetHeight: CGFloat = 310

	 var body: some View {
		  GeometryReader { geo in
				let paperWidth = geo.size.width
				let topHeight = paperWidth * topAssetHeight / assetWidth
				let bottomHeight = paperWidth * bottomAssetHeight / assetWidth
				let middleHeight = max(
					 geo.size.height - topHeight - bottomHeight,
					 paperWidth * middleAssetHeight / assetWidth
				)

				VStack(spacing: 0) {
					 Image("reader_paper_top_light")
						  .resizable()
						  .frame(width: .infinity, height: topHeight)

					 Image("reader_paper_middle_light")
						  .resizable(resizingMode: .stretch)
						  .frame(width: .infinity, height: middleHeight)

					 Image("reader_paper_bottom_light")
						  .resizable()
						  .frame(width: .infinity, height: bottomHeight)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		  }
	 }
}

#Preview {
    PaperBackGround()
}
