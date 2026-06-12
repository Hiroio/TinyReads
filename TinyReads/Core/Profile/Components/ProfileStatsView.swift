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
		VStack(spacing: 10){
		  Text("Statistic")
			 .title()
		  HStack(spacing: 5){
			 statCard(title: "Skiped", value: "\(vm.skippedCardsCount)")
			 statCard(title: "Saved", value: "\(vm.savedCardsCount)")
			 statCard(title: "Read", value: "\(vm.readedCardsCount)")
		  }
		  HStack{
			 Text("*Favorite Category*")
			 Text(vm.favoriteCategory)
				.accent()
			 
		  }
		  .padding(.top, 5)
		}
    }
}



@ViewBuilder
func statCard(title: String, value: String) -> some View{
  VStack{
	 Text("\(title):")
		.headline(weight: .light)
	 Text("\(value)")
		.accent()
  }
  .frame(maxWidth: .infinity)
  
}


#Preview {
    ProfileStatsView()
	 .environment(ProfileViewModel())
	 .environment(ThemeManager())
}
