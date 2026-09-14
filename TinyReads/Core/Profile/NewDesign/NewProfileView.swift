//
//  NewProfileView.swift
//  TinyReads
//
//  Created by user on 14.09.2026.
//

import SwiftUI

struct NewProfileView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefaultManager
  @State private var profileActionCard: ProfileActionBarEnum? = nil
    var body: some View {
		VStack{
		  if profileActionCard == .stamp{
			 StampView(){
				withAnimation{
				  profileActionCard = nil
				}
			 }
		  }else{
			 Text("Reader Card")
				.font(.title.weight(.bold))
			 
			 Button{
				withAnimation{
				  profileActionCard = .avatars
				}
			 }label:{
				Image("ProfileIcon\(userDefaultManager.selectedAvatarIndex)\(themeManager.themeAssets.id)")
				  .resizable()
				  .scaledToFit()
				  .overlay(alignment: .topTrailing) {
					 Image(systemName: "pencil")
						.font(.title3.weight(.black))
				  }
				  .containerRelativeFrame(.horizontal, count: 3, spacing: 0)
				  .foregroundStyle(themeManager.themeAssets.accent)
			 }
			 .tinyAccessibilityButton(ProfileActionBarEnum.avatars.accessibilityLabel, hint: ProfileActionBarEnum.avatars.accessibilityHint)
			 
			 
			 Spacer()
			 ProfileActionBar(profileActionCard: $profileActionCard)
		  }
		}
		.padding(.vertical, 40)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1/1.5, contentMode: .fit)
		.background(
		  PaperBackGround()
			 .scaleEffect(x: 1.05)
		)
		.rotation3DEffect(Angle(degrees: profileActionCard == .stamp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
		.sheet(isPresented: Binding(get: {
		  profileActionCard == .avatars
		}, set: { _ in
		  profileActionCard = nil
		})) {
		  ProfileAvatarSelectionView(){
			 profileActionCard = nil
		  }
		  .presentationDetents([.medium, .large])
			 .padding(.top)
			 .presentationBackground{
				PaperBackGround()
				  .ignoresSafeArea()
				  .scaleEffect(x: 1.1, y: 1.05)
			 }
		}
    }
}

#Preview {
    NewProfileView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
