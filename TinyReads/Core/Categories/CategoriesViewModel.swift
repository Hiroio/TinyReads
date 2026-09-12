//
//  CategoriesViewModel.swift
//  TinyReads
//
//  Created by user on 10.09.2026.
//

import SwiftUI
import StoreKit

@MainActor
@Observable
final class CategoriesViewModel {
  var animate: Bool = true
  var gridState: Bool = UIDevice.isIPad
  var selectedCategory: ReadCategories? = nil

  private let userDefaults = UserDefaultsManager.shared
  private let storeManager = StoreKitManager.shared

  init(){}
}


// MARK: - Navigation
extension CategoriesViewModel {
  func openCategory(_ category: ReadCategories?) {
    Task {
      withAnimation(.easeInOut(duration: 0.3)) {
        animate = false
      }

      try? await Task.sleep(for: .seconds(0.21))

      selectedCategory = category

      try? await Task.sleep(for: .seconds(0.1))

      withAnimation(.easeInOut(duration: 0.3)) {
        animate = true
      }
    }
  }

  func toggleGridState() {
    withAnimation {
      gridState.toggle()
    }
  }
}


// MARK: - SubCategory selection & purchasing
extension CategoriesViewModel {
  func isSelected(_ subCategory: any ReadSubCategory) -> Bool {
    userDefaults.selectedSubCategories.contains(subCategory.id)
  }
  
  func priceBadge(for subCategory: any ReadSubCategory) -> String? {
    guard let storeId = subCategory.storeId, !storeManager.isPurchased(storeId) else { return nil }
    return storeManager.product(for: storeId)?.displayPrice ?? "--.--$"
  }

  /// Free and already-owned subCategories toggle straight away; locked ones go through StoreKit.
  func select(_ subCategory: any ReadSubCategory) {
    guard let storeId = subCategory.storeId else { return toggle(subCategory) }
    guard !storeManager.isPurchased(storeId) else { return toggle(subCategory) }

    AnalyticsManager.shared.bookLockedTapped(subCategory)

    guard let product = storeManager.product(for: storeId) else {
      //  StoreKit shows no sheet of its own when the product never loaded (offline at launch),
      //  so the tap has to say something itself — and retry, so the next one can buy.
      showPopUp(.noConnection)
      AnalyticsManager.shared.purchaseFailed(productId: storeId, reason: "product_unavailable")
      Task { await storeManager.loadProducts(ids: [storeId]) }
      return
    }

    Task {
      //  cleared first so a stale message from an earlier failure can't be mistaken for this one
      storeManager.errorMessage = nil

      if await storeManager.purchase(product) {
        toggle(subCategory)
        showPopUp(.purchased)
      } else if storeManager.errorMessage != nil {
        //  purchase() also returns false when the user simply cancels — stay quiet in that case
        showPopUp(.error)
      }
    }
  }

  private func showPopUp(_ state: SmallPopUpEnum) {
    NavigationManager.shared.showPopUp(state)
  }

  private func toggle(_ subCategory: any ReadSubCategory) {
    if let index = userDefaults.selectedSubCategories.firstIndex(of: subCategory.id) {
      userDefaults.selectedSubCategories.remove(at: index)
      AnalyticsManager.shared.bookSelectionChanged(subCategory, selected: false, source: "shelf")
    } else {
      userDefaults.selectedSubCategories.append(subCategory.id)
      AnalyticsManager.shared.bookSelectionChanged(subCategory, selected: true, source: "shelf")
    }
  }
}
