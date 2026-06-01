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
    categoryIds: [String],
    languageCode: String,
    limit: Int = 100
  ) async throws -> [ReadCardModel] {
    guard !categoryIds.isEmpty else { return [] }

    return try await readsCollection
      .whereField("languageCode", isEqualTo: languageCode)
      .whereField("categoryId", in: categoryIds)
      .whereField("isActive", isEqualTo: true)
      .order(by: "sortIndex", descending: true)
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
