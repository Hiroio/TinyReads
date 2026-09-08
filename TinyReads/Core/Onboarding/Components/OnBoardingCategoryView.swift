//
//  OnBoardingCategoryView.swift
//  TinyReads
//
//  Created by user on 08.09.2026.
//

import SwiftUI

struct OnBoardingCategoryView: View {
  @Environment(UserDefaultsManager.self) var userDefaults
  @State private var categoriesToSelect: [any ReadSubCategory] = []

	 var body: some View {
		ScrollView{
		  LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
			 ForEach(categoriesToSelect, id: \.id){ subCategory in
				Button{
				  withAnimation {
					 toggle(subCategory)
				  }
				}label:{
				  VStack(spacing: 6){
					 Image(subCategory.image)
						.resizable()
						.scaledToFit()
						.overlay{
						  if isSelected(subCategory){
							 Color.black.opacity(0.35)
							 Image(systemName: "checkmark.circle.fill")
								.font(.title2)
								.foregroundStyle(.white)
						  }
						}
						.clipShape(.rect(cornerRadius: 8))

					 Text(subCategory.title)
						.font(.caption)
				  }
				}
				.buttonStyle(.plain)
			 }
		  }
		  .padding()
		}
		.onAppear{
		  animate()
		}
	 }

  private func isSelected(_ subCategory: any ReadSubCategory) -> Bool {
	 userDefaults.selectedSubCategories.contains(subCategory.id)
  }

  private func toggle(_ subCategory: any ReadSubCategory) {
	 if let index = userDefaults.selectedSubCategories.firstIndex(of: subCategory.id) {
		userDefaults.selectedSubCategories.remove(at: index)
	 } else {
		userDefaults.selectedSubCategories.append(subCategory.id)
	 }
  }

	 private func animate(){
		for (index, subCategory) in freeSubCategories().enumerated() {
		  Task{
			 try await Task.sleep(for: .seconds(Double(index) * 0.1))
			 withAnimation {
				self.categoriesToSelect.append(subCategory)
			 }
		  }
		}
	 }
}

#Preview {
  OnBoardingCategoryView()
	 .environment(UserDefaultsManager.shared)
}



extension OnBoardingCategoryView{
  private func freeSubCategories() -> [any ReadSubCategory] {
	 [
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
  }
}
