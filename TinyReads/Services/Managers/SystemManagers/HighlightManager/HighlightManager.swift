//
//  HighlightManager.swift
//  TinyReads
//
//  Created by user on 24.07.2026.
//

import Foundation
import CoreData


@Observable
final class HighlightManager{
  static let shared = HighlightManager()
  var highlights: [HighlightModel] = []
  
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  private init(){
	 let container = NSPersistentContainer(name: "Highlights")
	 container.loadPersistentStores { _, error in
		if let error{
		  print("DEBUG: Failed to load container for Highlights: \(error.localizedDescription)")
		}
	 }
	 
	 self.container = container
	 self.viewContext = container.viewContext
	 
	 syncHighlight()
  }
  
  
}




//MARK: CoreData Functions

extension HighlightManager{
//  MARK: - Fetch
  func fetchHighlights() -> [HighlightEntity]{
	 let request: NSFetchRequest<HighlightEntity> = NSFetchRequest(entityName: "HighlightEntity")
	 
	 do{
		let entities = try viewContext.fetch(request)
		return entities
	 }catch{
		
	 }
	 return []
  }
  
  func fetchSingleHighlight(id: UUID) -> HighlightEntity?{
	 let request: NSFetchRequest<HighlightEntity> = NSFetchRequest(entityName: "HighlightEntity")
	 
	 let predicate = NSPredicate(format: "id == %@", id as CVarArg)
	 request.predicate = predicate
	 
	 do{
		let entity = try viewContext.fetch(request).first
		return entity
	 }catch{
		return nil
	 }
	 
  }
  
  
//  MARK: - Actions
//  MARK: Create Highlight
  func createHighlight(highlight: HighlightModel) -> Bool{
	 let hightlightEntity = HighlightEntity(context: viewContext)
	 
	 hightlightEntity.id = UUID()
	 hightlightEntity.text = highlight.text
	 hightlightEntity.note = highlight.note
	 
	 hightlightEntity.originalId = highlight.originalId
	 hightlightEntity.originalTitle = highlight.originalTitle
	 hightlightEntity.categoryId = highlight.categoryId
	 
	 hightlightEntity.widgetIsActive = false
	 hightlightEntity.dateCreated = .now
	 
	 if save(){
		syncHighlight()
		return true
	 }
	 return false
  }
  
//  MARK: Edit Highlight
  func editHiglight(highlight: HighlightModel) -> Bool{
	 guard let entity = fetchSingleHighlight(id: highlight.id) else {return false}
	 
	 entity.note = highlight.note
	 entity.widgetIsActive = highlight.widgetIsActive
	 
	 
	 if save(){
		syncHighlight()
		return true
	 }
	 return false
  }
  
//  MARK: Delete Highlight
  func deleteHighlight(id: UUID) -> Bool{
	 guard let entity = fetchSingleHighlight(id: id) else {return false}
	 
	 viewContext.delete(entity)
	 
	 if save(){
		syncHighlight()
		return true
	 }
	 return false
  }
  
//  MARK: Sync Highlight
  func syncHighlight() {
	 let entities = fetchHighlights()
	 
	 self.highlights = entities.map( { HighlightModel(entity: $0) } )
  }
  
//   SAVE
  @discardableResult
  func save() -> Bool{
	 do{
		try viewContext.save()
	 }catch{
		return false
	 }
	 return true
  }
  
  
  
}
