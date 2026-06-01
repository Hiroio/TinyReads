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
		  
		  Text("Reader Card")
			 .title()
			 .frame(maxWidth: .infinity)
			 .foregroundStyle(themeManager.themeAssets.primary)
		  
		  Button{
			 withAnimation(.easeInOut){
				navigationManager.secondary = nil
			 }
		  }label:{
		  Image(systemName: "xmark")
			 .foregroundStyle(themeManager.themeAssets.accent)
			 .padding(5)
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
		
		HStack(spacing: 0){
		  ForEach(AppTheme.allCases, id: \.self){ item in
			 let active = item == themeManager.appTheme
			 let icon = active ? item.activeIcon : item.icon
			 Button{
				withAnimation(.easeInOut){
				  themeManager.appTheme = item
				}
			 }label: {
				Image(systemName: icon)
				  .font(.headline)
				  .foregroundStyle(themeManager.themeAssets.primary)
				  .padding()
				  .background(
					 Rectangle()
						.fill(active ? themeManager.themeAssets.border : .clear)
				  )
			 }
		  }
		}
		.cornerRadius(10)
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(themeManager.themeAssets.border ,lineWidth: 1)
		)
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
}
