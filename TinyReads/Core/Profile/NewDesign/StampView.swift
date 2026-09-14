//
//  StampView.swift
//  TinyReads
//
//  Created by user on 14.09.2026.
//

import SwiftUI

struct StampView: View {
  @Environment(ThemeManager.self) var themeManager
  let onDismiss: () -> ()
    var body: some View {
		VStack{
		  Text("Stamp Collection")
			 .font(.title2)
		  Text("Read different genres to collect stamps")
			 .font(.footnote)
		  LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
			 ForEach(0..<8){i in
				Image("StampFrame")
				  .resizable()
				  .scaledToFit()
				  .containerRelativeFrame(.vertical, count: 5, spacing: 50)
			 }
		  }
		}
		.overlay(alignment: .topTrailing){
		  Button{
			 onDismiss()
		  }label:{
			 Image(systemName: "arrow.turn.up.left")
				.font(.subheadline.weight(.black))
				.padding(.trailing, 30)
		  }
		}
		.foregroundStyle(themeManager.themeAssets.primary)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.fontDesign(.serif)
		.rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
    }
}

#Preview {
  StampView(){}
	 .environment(ThemeManager())
}
