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
		  ProfileAvatarCategoriesSection
		  
		  ProfileStatsView()
			 .environment(vm)
		  ProfileActionBar(profileActionCard: $profileActionCard)
			 .padding(.horizontal)
		  
		  ReferencesProfileView()
			 .padding(.bottom)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(UIDevice.isIPad ? 1.6 : 0.9 ,contentMode: .fit)
		.background(
		  Image(themeManager.themeAssets.readerCard)
			 .resizable()
			 .shadow(radius: 5)
		)
		.overlay(alignment: .topTrailing){
		  Button{
			 navigationManager.secondary = nil
		  }label:{
			 Image(systemName: "xmark")
				.fontWeight(.bold)
				.foregroundStyle(themeManager.themeAssets.primary)
				.padding(15)
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
					 .scaledToFit()
					 .shadow(color: .black.opacity(0.1),radius: 5)
				)
				.offset(y: -45)
		  }
		}
		.padding(.horizontal, UIDevice.isIPad ? 20 : 5)
		
		ProfileSecondaryView(profileActionCard: $profileActionCard)
		
	 }
	 .animation(.easeInOut, value: profileActionCard == nil)
  }
  
}


#Preview {
  ProfileView()
	 .environment(ThemeManager())
	 .environment(NavigationManager.shared)
	 .environment(UserDefaultsManager.shared)
}


extension ProfileView{
//  AVATAR Selection Btn And Title + Active Categories
  private var ProfileAvatarCategoriesSection: some View{
	 HStack(alignment: .top){
		Button{
		  withAnimation{
			 profileActionCard = .avatars
		  }
		}label:{
		  Image("ProfileIcon\(userDefaultManager.selectedAvatarIndex)\(themeManager.themeAssets.id)")
			 .resizable()
			 .scaledToFit()
			 .aspectRatio(1, contentMode: .fit)
			 .overlay(alignment: .topTrailing) {
				Image(systemName: "pencil")
				  .font(.title3.weight(.black))
			 }
			 .foregroundStyle(themeManager.themeAssets.accent)
		}
		.tinyAccessibilityButton(ProfileActionBarEnum.avatars.accessibilityLabel, hint: ProfileActionBarEnum.avatars.accessibilityHint)
		
		VStack{
		  Text("Reader Card")
			 .title(weight: .bold)
			 .frame(maxWidth: .infinity)
			 .foregroundStyle(themeManager.themeAssets.primary)
		  Text("Active categories:")
			 .secondary(weight: .bold)
		  CategoryShowCase
		}
		.frame(maxWidth: .infinity)
		.padding(.top)
	 }
	 .padding(.vertical)
	 .geometryGroup()
  }
  
  
  private var CategoryShowCase: some View{
	 ScrollView{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
		  ForEach(userDefaultManager.selectedCategories, id: \.self){item in
			 if let category = ReadCategories(rawValue: item){
				HStack{
				  Circle()
					 .fill(themeManager.themeAssets.secondary)
					 .frame(width: 2)
				  
				  Text(category.title)
					 .secondary()
				}
			 }
		  }
		}
	 }
  }
}
