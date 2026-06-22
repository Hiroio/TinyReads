//
//  CoreDataService.swift
//  TinyReads
//
//  Created by user on 01.06.2026.
//

import Foundation
import CoreData

final class CoreDataService{
  static let shared = CoreDataService()
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  private init(){
	 let initContainer = NSPersistentContainer(name: "Reads")
	 initContainer.loadPersistentStores { _, error in
		if let error{
#if DEBUG
		  print("Failed to load core data: \(error.localizedDescription)")
#endif
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
#if DEBUG
		print("Failed to save: \(error.localizedDescription)")
#endif
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
#if DEBUG
		print("Failed to fetch entities: \(error.localizedDescription)")
#endif
		return []
	 }
  }
  
  /// saving
  @discardableResult
  func markSaved(_ read: ReadInteractionModel) -> Bool {
	 let entity: ReadsEntity
	 if let loadedEntity = getSingleEntity(by: read.id){
		entity = loadedEntity
	 } else {
		entity = createNewEntity(read: read)
	 }
	 
	 entity.isSkipped = false
	 entity.isSaved = true
	 entity.savedAt = Date.now
	 
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
  func markRead(_ read: ReadInteractionModel) -> Bool{
	 let entity: ReadsEntity
	 if let loadedEntity = getSingleEntity(by: read.id){
		entity = loadedEntity
	 } else {
		entity = createNewEntity(read: read)
	 }
	 
	 entity.isRead = true
	 entity.isSkipped = false
	 entity.readAt = Date.now
	 
	 return self.save()
  }
  
  @discardableResult
  func markDismissed(_ read: ReadInteractionModel) -> Bool{
	 let entity: ReadsEntity
	 if let loadedEntity = getSingleEntity(by: read.id){
		entity = loadedEntity
	 } else {
		entity = createNewEntity(read: read)
	 }
	 
	 entity.isSkipped = true
	 entity.skippedAt = .now
	 entity.skipCount += 1
	 
	 return self.save()
  }
  
  
  /// get single entity (helper function)
  func getSingleEntity(by id: String) -> ReadsEntity?{
	 let request: NSFetchRequest<ReadsEntity> = NSFetchRequest(entityName: "ReadsEntity")
	 
	 request.predicate = NSPredicate(format: "id == %@", id)
	 
	 return try? viewContext.fetch(request).first
  }
  
  private func createNewEntity(read: ReadInteractionModel) -> ReadsEntity{
	 let entity = ReadsEntity(context: viewContext)
	 entity.update(from: read)
	 
	 return entity
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
#if DEBUG
		print("Failed to fetch entities: \(error.localizedDescription)")
#endif
		return []
	 }
  }
  func fetchDismissed() -> [ReadsEntity]{
	 let request: NSFetchRequest<ReadsEntity> = NSFetchRequest(entityName: "ReadsEntity")
	 let predicate = NSPredicate(format: "isSkipped == true")
	 request.predicate = predicate
	 
	 do{
		let entities = try viewContext.fetch(request)
		return entities
	 }catch{
#if DEBUG
		print("Failed to fetch entities: \(error.localizedDescription)")
#endif
		return []
	 }
  }
}
