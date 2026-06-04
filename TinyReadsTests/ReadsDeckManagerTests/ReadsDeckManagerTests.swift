//
//  ReadsDeckManagerTests.swift
//  TinyReadsTests
//
//  Created by user on 04.06.2026.
//

import Testing
@testable import TinyReads

@MainActor
struct ReadsDeckManagerTests {
  
  func makeSUT() -> (
			 manager: ReadsDeckManager,
			 firestore: MockFireStoreService,
			 userDefaults: UserDefaultsManagerProtocol
		) {
			 let firestore = MockFireStoreService()
			 let userDefaults = MockUserDefaultsManager()

			 let manager = ReadsDeckManager(
				  firestore: firestore,
				  userDefaultsManager: userDefaults,
				  autoLoad: false
			 )

			 return (manager, firestore, userDefaults)
		}

//  Testing if reads is empty then filter should return selected category with 0 as max sort index
    @Test func test_filterInteractions_withSelectedCategory_andEmptyReadInterection_ShouldReturnCategory_andMaxIndex0() {
//		Arrange
		var sut = makeSUT()
		let category = ReadCategories.philosophy.rawValue
		sut.userDefaults.selectedCategories = [category]
		
//		Act
		let filter = sut.manager.filterInteractions()
		
//		Assert
		#expect(filter.contains(where: { $0.key == category}))
		#expect(filter[category] == 0)
    }
  
  
//  Testing if reads interaction contain few models then should return the max sor index in with filterInteractions()
  @Test func test_filterInteraction_ReturnMaxSortIndexPerSelectedCategory_withItemsInInterectionReads_ShouldBeMaxIndex_FromReadInterection() {
//	 Arrange
	 var sut = makeSUT()
	 
	 let philosophyCategory = ReadCategories.philosophy.rawValue
	 let psycologyCategory = ReadCategories.psychology.rawValue
	 let maxIndex = 23
	 let categories = [philosophyCategory, psycologyCategory]
	 let readInterection = [ReadInteractionModel(id: "", categoryId: philosophyCategory, languageCode: "", sortIndex: maxIndex)]
	 
	 sut.userDefaults.selectedCategories = categories
	 sut.manager.readsInteractions = readInterection
//	 Act
	 let filter = sut.manager.filterInteractions()
	 
	 #expect(filter.keys.count == categories.count)
	 #expect(filter[philosophyCategory] == maxIndex)
	 #expect(filter[psycologyCategory] == 0)
  }
  
  @Test func test_filterInteractions_FromNotSelectedCategories_shouldBeEqualSelectedCategories() {
//	 Arrange
	 var sut = makeSUT()
	 
	 let philosophyCategory = ReadCategories.philosophy.rawValue
	 var categories: [String] = []
	 let maxIndex = 23
	 let readInterection = [ReadInteractionModel(id: "", categoryId: philosophyCategory, languageCode: "", sortIndex: maxIndex)]
	 
	 sut.userDefaults.selectedCategories = categories
	 sut.manager.readsInteractions = readInterection
	 
//	 ACT1
	 let filter = sut.manager.filterInteractions()
	 
//	 Assert1
	 #expect(filter.count == categories.count)
	 
//	 Act2
	 categories.append(philosophyCategory)
	 sut.userDefaults.selectedCategories = categories
	 
	 let filter2 = sut.manager.filterInteractions()
	 
//	 Assert2
	 #expect(filter2.count == categories.count)
	 #expect(filter2[philosophyCategory] == maxIndex)
	 
  }
  
  
  

}


// MARK: Fetch Testing
extension ReadsDeckManagerTests{
  @Test func test_FetchFromFireStore_ShouldReturnFirst10Reads_withSelectedCategory() async throws {
//	 Arrange
	 var sut = makeSUT()
	 let philosophyCategory = ReadCategories.philosophy.rawValue
	 let categories = [philosophyCategory]
	 let limitPerCategory = 10
	 
//	 Act
	 sut.userDefaults.selectedCategories = categories
	 
	 let filter = sut.manager.filterInteractions()
	 let reads = try? await sut.firestore.fetchReads(categoryProgress: filter, languageCode: "uk", limitPerCategory: limitPerCategory)
	 let lastSortIndex = reads?.sorted(by: {$0.sortIndex > $1.sortIndex}).first?.sortIndex
	 
//	 Assert
	 #expect(reads?.count == limitPerCategory)
	 #expect(lastSortIndex == limitPerCategory)
  }
  
  
  @Test func test_FetchFromFireStore__withSelectedCategory_withReadInteraction_ShouldReturnSortIndexFromFilter() async throws {
//	 Arrange
	 var sut = makeSUT()
	 let maxIndex = 23
	 let nextIndex = maxIndex + 1
	 let limitPerCategory = 10
	 let philosophyCategory = ReadCategories.philosophy.rawValue
	 let readInterection = [ReadInteractionModel(id: "", categoryId: philosophyCategory, languageCode: "", sortIndex: maxIndex)]
	 
//	 Act
	 sut.userDefaults.selectedCategories = [philosophyCategory]
	 sut.manager.readsInteractions = readInterection
	 let filter = sut.manager.filterInteractions()
	 
	 
	 let reads = try await sut.firestore.fetchReads(categoryProgress: filter, languageCode: "uk", limitPerCategory: limitPerCategory)
	 
	 let sortedReads = reads.sorted(by: {$0.sortIndex < $1.sortIndex})
	 let first = sortedReads.first
	 let last = sortedReads.last
	 
//	 Assert
	 #expect(filter[philosophyCategory] == maxIndex)
	 #expect(first?.sortIndex == nextIndex)
	 #expect(last?.sortIndex == maxIndex + limitPerCategory)
	 #expect(sortedReads.count == limitPerCategory)
  }
  
}

