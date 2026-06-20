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
				.overlay(alignment: .trailing) {
				  Button{onDismiss()}label:{
					 Image(systemName: "xmark")
						.font(.headline.weight(.bold))
				  }
				}
				.foregroundStyle(themeManager.themeAssets.primary)
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
						Text(active ? "*Selected*" : "")
						  .font(.footnote.weight(.black))
						  .foregroundStyle(themeManager.themeAssets.accent)
					 }
				  }
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
    }
}

#Preview {
  ProfileAvatarSelectionView(){}
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
