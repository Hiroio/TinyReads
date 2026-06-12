//
//  ProfileView.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import SwiftUI

struct ProfileView: View {
  @Environment(NavigationManager.self) var navigationManager
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @State private var profileActionCard: ProfileActionBarEnum? = nil
  @State private var vm = ProfileViewModel()
  
  var body: some View {
	 ZStack{
		VStack(spacing: 0){
		  
		  HStack(alignment: .top){
			 Image("ProfileImage")
				.resizable()
				.scaledToFit()
				.frame(width: 135)
			 
			 VStack{
				Text("Reader Card")
				  .title()
				  .frame(maxWidth: .infinity)
				  .foregroundStyle(themeManager.themeAssets.primary)
				
				CategoryShowCase
			 }
		  }
		  .padding(.vertical)

		  ProfileStatsView()
			 .environment(vm)
		  
		  ProfileActionBar(profileActionCard: $profileActionCard)
		}
		.padding()
		.padding()
		.background(
		  Image(themeManager.themeAssets.readerCard)
			 .resizable()
			 
		)
		.padding(.horizontal, 10)
		
		
		
		if let profileActionCard{
		  ZStack{
			 Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
				self.profileActionCard = nil
			 }
			 switch profileActionCard {
			 case .language:
				//			 TODO: LANGUAGE LIST
				EmptyView()
			 case .theme:
				ThemeSelectorView(){
				  withAnimation{
					 self.profileActionCard = nil
				  }
				}
				  .zIndex(1)
				  .transition(.opacity)
			 case .categories:
				  CategoriesView()
					 .zIndex(1)
					 .transition(.opacity)
				}
		  }
		  .allowsHitTesting(self.profileActionCard != nil)
		}
	 }
  }
  
  
//  Category showcase:
  private var CategoryShowCase: some View{
	 VStack{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
		  ForEach(userDefaultManager.selectedCategories, id: \.self){category in
			 Text(category)
				.secondary()
		  }
		}
	 }
  }
}


#Preview {
    ProfileView()
	 .environment(ThemeManager())
	 .environment(NavigationManager.shared)
	 .environment(UserDefaultsManager.shared)
}
