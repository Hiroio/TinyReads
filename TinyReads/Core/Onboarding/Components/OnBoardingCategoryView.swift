//
//  OnBoardingCategoryView.swift
//  TinyReads
//
//  Created by user on 08.09.2026.
//

import SwiftUI

struct OnBoardingCategoryView: View {
  @Environment(ThemeManager.self) var themeManager
  @Environment(UserDefaultsManager.self) var userDefaults
  @State private var categoriesToSelect: [any ReadSubCategory] = [
	 CultureSubCategory.cultureUniversal,
		FinanceSubCategory.financeUniversal,
		HealthSubCategory.healthUniversal,
		HistorySubCategory.historyUniversal,
		NatureSubCategory.natureUniversal,
		PhilosophySubCategory.philosophyUniversal,
		PsychologySubCategory.psychologyUniversal,
		ScienceSubCategory.scienceUniversal,
		TechnologySubCategory.technologyUniversal
	 ]
  
  var body: some View {
	 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
		ForEach(categoriesToSelect, id: \.id){ subCategory in
		  Button{
			 withAnimation {
				toggle(subCategory)
			 }
		  }label:{
			 VStack(spacing: 0){
				let active = userDefaults.selectedSubCategories.contains(subCategory.id)
				Image("\(subCategory.image)\(themeManager.colorScheme == .light ? "Light" : "Dark")")
				  .resizable()
				  .scaledToFit()
				  .shadow(color: active ? themeManager.themeAssets.accent : .clear,radius: 5)
				  .shadow(color: active ? themeManager.themeAssets.accent : .clear,radius: 5)
				
				  .overlay(alignment: .topTrailing){
					 if isSelected(subCategory){
						Image(systemName: "checkmark")
						  .font(.title2.weight(.medium))
						  .foregroundStyle(themeManager.themeAssets.background)
						  .shadow(color: themeManager.themeAssets.primary, radius: 2)
						  .padding(15)
					 }
				  }
				
				Text(subCategory.category.capitalized)
				  .font(.footnote.weight(.semibold))
				  .offset(y: -10)
			 }
		  }
		  .buttonStyle(.plain)
		}
	 }
	 .padding(25)
	 .background(
		PaperBackGround()
		  .scaleEffect(x: 1.1)
	 )
  }
  
  private func isSelected(_ subCategory: any ReadSubCategory) -> Bool {
	 userDefaults.selectedSubCategories.contains(subCategory.id)
  }
  
  private func toggle(_ subCategory: any ReadSubCategory) {
	 if let index = userDefaults.selectedSubCategories.firstIndex(of: subCategory.id) {
		userDefaults.selectedSubCategories.remove(at: index)
		AnalyticsManager.shared.bookSelectionChanged(subCategory, selected: false, source: "onboarding")
	 } else {
		userDefaults.selectedSubCategories.append(subCategory.id)
		AnalyticsManager.shared.bookSelectionChanged(subCategory, selected: true, source: "onboarding")
	 }
  }
}

#Preview {
  OnBoardingCategoryView()
	 .environment(ThemeManager())
	 .environment(UserDefaultsManager.shared)
}
