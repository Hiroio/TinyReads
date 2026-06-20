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
		  VStack{
			 Text("Reader Information:")
				.headline(weight: .bold)
				.frame(maxWidth: .infinity, alignment: .leading)
			 HStack(alignment: .bottom, spacing: 5){
				statCard(title: "Dismissed", value: "\(vm.skippedCardsCount)")
				statCard(title: "Read", value: "\(vm.readedCardsCount)")
				statCard(title: "Saved", value: "\(vm.savedCardsCount)")
			 }
			 .padding(.vertical, 10)
		  }
		  .padding(.horizontal)
		  HStack{
			 Text("Favorite Category: ")
				.headline(weight: .semibold)
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
  VStack{
	 Text("\(title):")
		.secondary(weight: .semibold)
	 Text("\(value)")
		.accent(weight: .bold)
		.italic()
  }
  .frame(maxWidth: .infinity)
  
}


#Preview {
    ProfileStatsView()
	 .environment(ProfileViewModel())
	 .environment(ThemeManager())
}
