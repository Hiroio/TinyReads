//
//  ProfileSecondaryView.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

struct ProfileSecondaryView: View {
  @Binding var profileActionCard: ProfileActionBarEnum?
  var body: some View {
	 switch profileActionCard {
	 case .language:
		ZStack{
		  Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
			 self.profileActionCard = nil
		  }
		  .tinyAccessibilityHidden()
		  ProfileLanguageView() {
			 withAnimation{
				self.profileActionCard = nil
			 }
		  }
		  .transition(.opacity)
		}
		.zIndex(2)
		.allowsHitTesting(self.profileActionCard != nil)
	 case .theme:
		ZStack{
		  Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
			 self.profileActionCard = nil
		  }
		  .tinyAccessibilityHidden()
		  ThemeSelectorView(){
			 withAnimation{
				self.profileActionCard = nil
			 }
		  }
		  .transition(.opacity)
		}
		.zIndex(2)
		.allowsHitTesting(self.profileActionCard != nil)
	 case .categories:
		ZStack{
		  Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
			 self.profileActionCard = nil
		  }
		  .tinyAccessibilityHidden()
		  CategoriesView(secondary: false) {
			 withAnimation{
				self.profileActionCard = nil
			 }
		  }
		  .transition(.opacity)
		}
		.zIndex(2)
		.allowsHitTesting(self.profileActionCard != nil)
	 case .avatars:
		ZStack{
		  Color.black.opacity(0.1).ignoresSafeArea().onTapGesture {
			 self.profileActionCard = nil
		  }
		  .tinyAccessibilityHidden()
		  ProfileAvatarSelectionView() {
			 withAnimation{
				self.profileActionCard = nil
			 }
		  }
		  .transition(.move(edge: .bottom).combined(with: .opacity))
		}
		.allowsHitTesting(self.profileActionCard != nil)
		.zIndex(2)
	 default:
		EmptyView()
	 }
  }
}

#Preview {
  ProfileSecondaryView(profileActionCard: .constant(nil))
}
