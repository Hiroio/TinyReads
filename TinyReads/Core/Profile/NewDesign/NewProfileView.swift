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
  @State private var vm: ProfileViewModel = ProfileViewModel()
    var body: some View {
		VStack{
		  if profileActionCard == .stamp{
			 StampView(){
				withAnimation{
				  profileActionCard = nil
				}
			 }
		  }else{
			 VStack{
				Header
				
				Spacer()
				VStack(spacing: 15){
				  statisticOption(name: "Read", value: "\(vm.readedCardsCount)")
				  statisticOption(name: "Saved", value: "\(vm.savedCardsCount)")
				  statisticOption(name: "Dismissed", value: "\(vm.skippedCardsCount)")
				  statisticOption(name: "Word read", value: "\(vm.wordsReadCount)")
				  statisticOption(name: "Reading time", value: vm.readTime)
				  
				}
				.padding(.horizontal, 35)
				Spacer()
				ProfileActionBar(profileActionCard: $profileActionCard)
			 }
			 .frame(maxWidth: .infinity)
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


extension NewProfileView{
  func statisticOption(name: String, value: String) -> some View{
	 HStack(alignment: .bottom){
		Text(name)
		  .headline()
		StraightLine()
		  .stroke(style: .init(lineWidth: 3, dash: [4, 10]))
		  .frame(height: 1)
		Text(value)
		  .headline(weight: .bold)
	 }
  }
  
  private var Header: some View{
	 HStack(alignment: .top){
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
		
		
		Text("Reader Card")
		  .font(.title2.weight(.bold))
		  .padding(.leading)
		
		
	 }
  }
}
