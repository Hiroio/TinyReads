//
//  JSONUploader.swift
//  TinyReads
//
//  Created by user on 28.05.2026.
//

import Foundation
import FirebaseFirestore

@Observable
final class JSONUploader{
  var isUploading = false
  var statusMessage: String = "ready to start"
  
  func startUpload() {
			 uploadLocalJSONToFirestore(fileName: "English_Space")
			 uploadLocalJSONToFirestore(fileName: "Ukraine_Space")

		}
		
		func uploadLocalJSONToFirestore(fileName: String) {
			 guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
				  statusMessage = "File \(fileName).json not found"
				  isUploading = false
				  return
			 }
			 
			 do {
				  let data = try Data(contentsOf: url)
				  
				  
				  let decodedData = try JSONDecoder().decode(RootReads.self, from: data)
				  
				  let db = Firestore.firestore()
				  let batch = db.batch()
				  
				  for card in decodedData.reads {
						let docRef = db.collection("reads").document(card.id)
						
						// Просто перетворюємо модель у словник і додаємо в батч
						let cardDict = try Firestore.Encoder().encode(card)
						batch.setData(cardDict, forDocument: docRef)
				  }
				  
				  batch.commit { error in
					 self.isUploading = false
						if let error = error {
						  self.statusMessage = "Error: \(error.localizedDescription)"
						} else {
						  self.statusMessage = "Successfully uploaded \(decodedData.reads.count) cards from \(fileName)!"
						}
				  }
				  
			 } catch {
				  isUploading = false
				  statusMessage = "Parse error: \(error.localizedDescription)"
#if DEBUG
				  print("Full error: \(error)")
#endif
			 }
		}
}
