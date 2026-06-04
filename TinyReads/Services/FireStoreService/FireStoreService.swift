//
//  FireStoreService.swift
//  TinyReads
//
//  Created by user on 31.05.2026.
//

import Foundation
import FirebaseFirestore

final class FireStoreService: PublicReadsServiceProtocol {
  static let shared = FireStoreService()

  private let fireStore: Firestore

  private init(fireStore: Firestore = Firestore.firestore()) {
    self.fireStore = fireStore
  }

  private var readsCollection: Query {
    fireStore.collectionGroup("reads")
  }
}




extension FireStoreService{

  func fetchReads(
    categoryProgress: [String: Int],
    languageCode: String,
    limitPerCategory: Int = 100
  ) async throws -> [ReadCardModel] {
    guard !categoryProgress.isEmpty else { return [] }

    return try await withThrowingTaskGroup(of: [ReadCardModel].self) { group in
      for (categoryId, lastSortIndex) in categoryProgress {
        group.addTask { [self] in
          try await fetchReads(
            categoryId: categoryId,
            languageCode: languageCode,
            afterSortIndex: lastSortIndex,
            limit: limitPerCategory
          )
        }
      }

      var reads: [ReadCardModel] = []

      for try await categoryReads in group {
        reads.append(contentsOf: categoryReads)
      }

      return reads
    }
  }

  private func fetchReads(
    categoryId: String,
    languageCode: String,
    afterSortIndex: Int,
    limit: Int
  ) async throws -> [ReadCardModel] {
    try await readsCollection
      .whereField("languageCode", isEqualTo: languageCode)
      .whereField("categoryId", isEqualTo: categoryId)
      .whereField("isActive", isEqualTo: true)
      .whereField("sortIndex", isGreaterThan: afterSortIndex)
      .order(by: "sortIndex", descending: false)
      .limit(to: limit)
      .getDocumentsCustom()
  }
}



enum ReadCategories: String, CaseIterable, Identifiable{
  case science, history, culture, psychology, philosophy
  
  var id: String { self.rawValue}
}





import Combine
extension Query{
	 func getDocumentsCustom<T: Decodable>() async throws -> [T]{
		  return try await getDocumentsCustomWithSnapshot().product as [T]
	 }
	 
	 
	 func getDocumentsCustomWithSnapshot<T: Decodable>() async throws -> (product: [T], lastDocument: DocumentSnapshot?){
		  let data = try await self.getDocuments()
		  
		  let product = try data.documents.map({
				try $0.data(as: T.self)
		  })
		  return (product, data.documents.last)
	 }
	 
	 func start(afterDocument lastDocument: DocumentSnapshot?) -> Query{
		  if let lastDocument{
				return self.start(afterDocument: lastDocument)
		  }else{
				return self
		  }
	 }
  
  func addSnapshotListener<T: Decodable>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration){
	 let publisher = PassthroughSubject<[T], Error>()
	 let listener = self.addSnapshotListener { querySnapshot, error in
		guard let documents = querySnapshot?.documents else{
		  print("no documents")
		  return
		}
		let products : [T] = documents.compactMap({ try? $0.data(as: T.self)})
		
		publisher.send(products)
	 }
	 return (publisher.eraseToAnyPublisher(), listener)
  
  }
}
