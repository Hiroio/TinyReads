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
			 Button{
				profileActionCard = .avatars
			 }label:{
				Image("ProfileIcon\(userDefaultManager.selectedAvatarIndex)\(themeManager.themeAssets.id)")
				  .resizable()
				  .scaledToFit()
				  .aspectRatio(1, contentMode: .fit)
				  .overlay(alignment: .topTrailing) {
					 Image(systemName: "pencil")
						.font(.headline.weight(.black))
				  }
				  .foregroundStyle(themeManager.themeAssets.primary)
			 }
			 .frame(maxWidth: .infinity)
			 
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
		  .frame(maxWidth: .infinity)
		  
		  ProfileStatsView()
			 .environment(vm)
			 
		  
		  ProfileActionBar(profileActionCard: $profileActionCard)
			 .padding(.horizontal)
		}
		.padding()
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
				.offset(y: -55)
		  }
		}
		.padding(.horizontal, 5)
		.padding(.vertical)
		
		SecondaryViews
	
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
  @ViewBuilder
  private var SecondaryViews: some View{
	 if let profileActionCard{
		ZStack{
		  Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
			 self.profileActionCard = nil
		  }
		  switch profileActionCard {
		  case .language:
			 ProfileLanguageView() {
				withAnimation{
				  self.profileActionCard = nil
				}
			 }
			 .zIndex(2)
			 .transition(.opacity)
		  case .theme:
			 ThemeSelectorView(){
				withAnimation{
				  self.profileActionCard = nil
				}
			 }
			 .zIndex(2)
			 .transition(.opacity)
		  case .categories:
			 CategoriesView(secondary: false) {
				withAnimation{
				  self.profileActionCard = nil
				}
			 }
			 .zIndex(2)
			 .transition(.opacity)
		  case .avatars:
			 ProfileAvatarSelectionView() {
				withAnimation{
				  self.profileActionCard = nil
				}
			 }
			 .zIndex(2)
			 .transition(.move(edge: .bottom).combined(with: .opacity))
		  }
		}
		.allowsHitTesting(self.profileActionCard != nil)
	 }
  }
  
  
  private var CategoryShowCase: some View{
	 VStack{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
		  ForEach(userDefaultManager.selectedCategories, id: \.self){category in
			 Text("-\(category)")
				.secondary()
		  }
		}
	 }
  }
}
