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

  private var unlockedStamps: [ReadCategories]{
	 ReadCategories.allCases.filter { UserDefaults.standard.bool(forKey: $0.stamp) }
  }

    var body: some View {
		VStack{
		  Text("Stamp Collection")
			 .font(.title2)
		  Text("Read different genres to collect stamps")
			 .font(.footnote)
		  if unlockedStamps.isEmpty{
			 VStack{
				Image(themeManager.themeAssets.emptyState)
				  .resizable()
				  .scaledToFit()

				Text("No stamps yet")
				  .title()
				  .padding()
			 }
			 .aspectRatio(1.5, contentMode: .fit)
		  }else{
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
			 ForEach(ReadCategories.allCases){i in
				ZStack{
				  Image(i.stamp + "\(themeManager.colorScheme == .dark ? "Dark" : "Light")")
					 .resizable()
					 .scaledToFit()
				}
				  .containerRelativeFrame(.vertical, count: 5, spacing: 50)
				  .opacity(UserDefaults.standard.bool(forKey: i.stamp) ? 1 : 0 )
			 }
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

