//
//  CoreDataService.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation
import CoreData

class CoreDataService{
  static let shared = CoreDataService()
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  private init(){
	 let initContainer = NSPersistentContainer(name: "Reads")
	 initContainer.loadPersistentStores { _, error in
		if let error{
		  print("Failed to load core data: \(error.localizedDescription)")
		}
	 }
	 
	 self.container = initContainer
	 self.viewContext = initContainer.viewContext
  }
  
  @discardableResult
  func save() -> Bool{
	 do{
		try viewContext.save()
		return true
	 }catch{
		print("Failed to save: \(error.localizedDescription)")
		return false
	 }
  }
}

// MARK: Reads Entity
extension CoreDataService{
  /// fetching
  func fetchReadsEntity() -> [ReadsEntity]{
	 let request: NSFetchRequest<ReadsEntity> = NSFetchRequest(entityName: "ReadsEntity")
	 
	 do{
		let entities = try viewContext.fetch(request)
		return entities
	 }catch{
		print("Failed to fetch entities: \(error.localizedDescription)")
		return []
	 }
  }
  
  /// saving
  @discardableResult
  func saveReadEntity(_ read: ReadInteractionModel) -> Bool {
	 let entity = ReadsEntity(context: viewContext)
	 
	 entity.update(from: read)
	 
	 return self.save()
  }
  
 
  
  /// unsafe entity
  @discardableResult
  func removeFromSaving(_ id: String) -> Bool {
	 guard let entity = getSingleEntity(by: id) else {return false}
	 
	 entity.isSaved = false
	 entity.savedAt = nil
	 
	 return self.save()
  }
  
  /// mark read
  @discardableResult
  func markRead(_ id: String) -> Bool{
	 guard let entity = getSingleEntity(by: id) else {return false}
	 
	 entity.isRead = true
	 entity.readAt = Date.now
	 
	 return self.save()
  }
  
  @discardableResult
  func markDismissed(_ id: String) -> Bool{
	 guard let entity = getSingleEntity(by: id) else {return false}
	 
	 entity.isSkipped = true
	 entity.skippedAt = .now
	 entity.skipCount += 1
	 
	 return self.save()
  }
  
  
  /// get single entity (helper function)
  private func getSingleEntity(by id: String) -> ReadsEntity?{
	 let request: NSFetchRequest<ReadsEntity> = NSFetchRequest(entityName: "ReadsEntity")
	 
	 request.predicate = NSPredicate(format: "id == %@", id)
	 
	 return try? viewContext.fetch(request).first
  }
}

//MARK: Archive
extension CoreDataService {
  func fetchSavedOrReaded() -> [ReadsEntity]{
	 let request: NSFetchRequest<ReadsEntity> = NSFetchRequest(entityName: "ReadsEntity")
	 let predicate = NSPredicate(format: "isRead == true || isSaved == true")
	 request.predicate = predicate
	 
	 do{
		let entities = try viewContext.fetch(request)
		return entities
	 }catch{
		print("Failed to fetch entities: \(error.localizedDescription)")
		return []
	 }
  }
}
