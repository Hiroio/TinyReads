//
//  ProfileAvatarSelectionView.swift
//  TinyReads
//
//  Created by user on 20.06.2026.
//

import SwiftUI

struct ProfileAvatarSelectionView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefault
  let onDismiss: () -> ()
    var body: some View {
		ScrollView{
		  LazyVStack{
			 Text("Avatars")
				.title(weight: .semibold)
				.frame(maxWidth: .infinity)
			 LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 2), spacing: 15){
				ForEach(0...19, id: \.self){index in
				  let active = index == userDefault.selectedAvatarIndex
				  Button{
					 withAnimation(.easeInOut){
						userDefault.selectedAvatarIndex = index
					 }
				  }label:{
					 VStack{
						Image("ProfileIcon\(index)\(themeManager.themeAssets.id)")
						  .resizable()
						  .aspectRatio(contentMode: .fit)
						  .shadow(color: themeManager.themeAssets.accent.opacity(0.6),radius: active ? 10 : 0)
						  .opacity(active ? 1 : 0.7)
						Text(active ? "Selected" : "")
						  .font(.subheadline.weight(.black))
						  .foregroundStyle(themeManager.themeAssets.accent)
					 }
				  }
				  .tinyAccessibilityButton(active ? "Selected avatar" : "Select avatar")
				}
			 }
		  }
		  .padding(40)
		  .frame(maxHeight: .infinity)
		  .ignoresSafeArea(edges: .bottom)
		  .background(
			 PaperBackGround()
		  )
		}
		.overlay(alignment: .topTrailing) {
		  Button{onDismiss()}label:{
			 Image(systemName: "xmark")
				.font(.headline.weight(.bold))
				.padding(15)
				.background(
				  Image(themeManager.themeAssets.backSmallCard)
					 .resizable()
					 .scaledToFit()
					 .shadow(color: .black.opacity(0.1),radius: 5)
				)
		  }
		  .tinyAccessibilityButton("Close")
		}
		.foregroundStyle(themeManager.themeAssets.primary)
    }
}

#Preview {
  ProfileAvatarSelectionView(){}
	 .environment(ThemeManager())	
	 .environment(UserDefaultsManager.shared)
	 .environment(\.locale, Locale(identifier: "en"))
}
