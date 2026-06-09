//
//  ArchiveCard.swift
//  TinyReads
//
//  Created by user on 09.06.2026.
//

import SwiftUI

struct ArchiveCard: View {
  @Environment(ThemeManager.self) var themeManager
  let read: ReadCardModel
    var body: some View {
		VStack{
		  Text(read.title)
			 .secondary()
			 .multilineTextAlignment(.center)
			 .frame(maxWidth: .infinity, maxHeight: .infinity)
			 .aspectRatio(1, contentMode: .fit)
			 .background(
				Image("backGroundCard")
				  .resizable()
				  .scaledToFit()
			 )
			 .allowsTightening(true)
			 
		}
    }
}

#Preview {
  ArchiveCard(read: .getForPreview())
	 .environment(ThemeManager())
}
