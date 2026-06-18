//
//  ProfileStatsView.swift
//  TinyReads
//
//  Created by user on 12.06.2026.
//

import SwiftUI

struct ProfileStatsView: View {
  @Environment(ProfileViewModel.self) var vm
    var body: some View {
		VStack(alignment: .leading, spacing: 10){
		  Text("Reader Information:")
			 .headline()
			 .frame(maxWidth: .infinity, alignment: .leading)
		  VStack(alignment: .leading, spacing: 5){
			 statCard(title: "Dismissed Cards", value: "\(vm.skippedCardsCount)")
			 statCard(title: "Saved Cards", value: "\(vm.savedCardsCount)")
			 statCard(title: "Read Cards", value: "\(vm.readedCardsCount)")
		  }
		  .padding(.horizontal)
		  HStack{
			 Text("Favorite Category: ")
				.headline()
			 Text(vm.favoriteCategory)
				.accent()
				.italic()
			 
		  }
		  .padding(.top, 5)
		}
    }
}



@ViewBuilder
func statCard(title: String, value: String) -> some View{
  HStack{
	 Text("\(title):")
		.secondary(weight: .medium)
	 Text("\(value)")
		.accent()
		.italic()
  }
  .frame(maxWidth: .infinity, alignment: .leading)
  
}


#Preview {
    ProfileStatsView()
	 .environment(ProfileViewModel())
	 .environment(ThemeManager())
}
