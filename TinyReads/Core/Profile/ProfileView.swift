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
  var body: some View {
	 VStack(spacing: 15){
		
		HStack(alignment: .top){
		  Image("ProfileImage")
			 .resizable()
			 .scaledToFit()
			 .frame(width: 105)
			 .cornerRadius(10)
			 .background(
				RoundedRectangle(cornerRadius: 10)
				  .stroke(themeManager.themeAssets.border)
			 )
		  
		  VStack{
			 Text("Reader Card")
				.title()
				.frame(maxWidth: .infinity)
				.foregroundStyle(themeManager.themeAssets.primary)
			
			 VStack{
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)){
				  ForEach(userDefaultManager.selectedCategories, id: \.self){category in
					 Text(category)
						.secondary()
				  }
				}
				Button{
				  NavigationManager.shared.secondary = .category
				}label: {
				  Text("Change Categories")
					 .accent()
				}
			 }
			 .padding(5)
			 .background(
				RoundedRectangle(cornerRadius: 10)
				  .stroke(themeManager.themeAssets.border , lineWidth: 1)
			 )
		  }
		}
		
		HStack{
		  statCard(title: "Read", value: 0)
		  statCard(title: "Saved", value: 0)
		  statCard(title: "Dismissed", value: 0)
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(themeManager.themeAssets.border, lineWidth: 1)
		)
		
		ThemeSelectorView()
	 }
	 .padding()
	 .background(
		ZStack{
		  RoundedRectangle(cornerRadius: 10)
			 .fill(themeManager.themeAssets.card)
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(themeManager.themeAssets.border, lineWidth: 1)
			 .padding(10)
		}
	 )
	 .overlay(
		Button{
		  withAnimation(.easeInOut){
			 navigationManager.secondary = nil
		  }
		}label:{
		Image(systemName: "xmark")
		  .foregroundStyle(themeManager.themeAssets.accent)
		  .padding()
	 },
		alignment: .topTrailing
	 )
	 .padding(.horizontal)
  }
}

@ViewBuilder
func statCard(title: String, value: Int) -> some View{
  VStack{
	 Text(title)
		.secondary()
	 Text("\(value)")
		.title()
  }
  .frame(maxWidth: .infinity)
}

#Preview {
    ProfileView()
	 .environment(ThemeManager())
	 .environment(NavigationManager.shared)
	 .environment(UserDefaultsManager.shared)
}
