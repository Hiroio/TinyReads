//
//  StoreKitManager.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import Foundation
import StoreKit

enum StoreKitManagerError: Error {
  case failedVerification
}

@Observable
final class StoreKitManager{
  static let shared = StoreKitManager()

// Loaded products
  private(set) var products: [Product] = []
//  Purchased products
  private(set) var purchasedProductIDs: Set<String> = []

  var isLoadingProducts = false
  var purchasingProductID: String? = nil
  var errorMessage: String? = nil

  private var transactionListener: Task<Void, Never>? = nil

  private init(){
	 transactionListener = listenForTransactionUpdates()

	 Task{
		await loadPurchasedProducts()
	 }
  }

  deinit{
	 transactionListener?.cancel()
  }
}


//  MARK: - Purchasing
extension StoreKitManager{

  func product(for id: String) -> Product?{
	 products.first(where: { $0.id == id })
  }

  @MainActor
  func loadProducts(ids: [String]) async{
	 guard !ids.isEmpty else { return }
	 isLoadingProducts = true
	 defer{ isLoadingProducts = false }

	 do{
		let storeProducts = try await Product.products(for: ids)
		self.products = storeProducts.sorted(by: { $0.price < $1.price })
	 }catch{
		errorMessage = "Couldn't load products. Check your connection and try again."
	 }
  }

  @discardableResult
  @MainActor
  func purchase(_ product: Product) async -> Bool{
	 purchasingProductID = product.id
	 defer{ purchasingProductID = nil }

	 do{
		let result = try await product.purchase()

		switch result{
		case .success(let verification):
		  let transaction = try checkVerified(verification)
		  await updatePurchasedProducts(with: transaction)
		  await transaction.finish()
		  return true
		case .userCancelled, .pending:
		  return false
		@unknown default:
		  return false
		}
	 }catch{
		errorMessage = "The purchase couldn't be completed."
		return false
	 }
  }
}


//  MARK: - Purchase Tracking
extension StoreKitManager{

  func isPurchased(_ productID: String) -> Bool{
	 purchasedProductIDs.contains(productID)
  }

  @MainActor
  func restorePurchases() async{
	 do{
		try await AppStore.sync()
		await loadPurchasedProducts()
	 }catch{
		errorMessage = "Couldn't restore your purchases."
	 }
  }

  @MainActor
  func loadPurchasedProducts() async{
	 var owned: Set<String> = []

	 for await result in Transaction.currentEntitlements{
		guard let transaction = try? checkVerified(result), transaction.revocationDate == nil else{ continue }
		owned.insert(transaction.productID)
	 }

	 self.purchasedProductIDs = owned
  }

  @MainActor
  func updatePurchasedProducts(with transaction: Transaction) async{
//	 Consumables (tips) are never part of entitlements, so only persist ownership for the rest.
	 guard transaction.productType != .consumable else{ return }

	 if transaction.revocationDate == nil{
		purchasedProductIDs.insert(transaction.productID)
	 }else{
		purchasedProductIDs.remove(transaction.productID)
	 }
  }

  func listenForTransactionUpdates() -> Task<Void, Never>{
	 Task.detached{ [weak self] in
		for await update in Transaction.updates{
		  guard let self, let transaction = try? self.checkVerified(update) else{ continue }
		  await self.updatePurchasedProducts(with: transaction)
		  await transaction.finish()
		}
	 }
  }

  func checkVerified<T>(_ result: VerificationResult<T>) throws -> T{
	 switch result{
	 case .unverified:
		throw StoreKitManagerError.failedVerification
	 case .verified(let safe):
		return safe
	 }
  }
}
