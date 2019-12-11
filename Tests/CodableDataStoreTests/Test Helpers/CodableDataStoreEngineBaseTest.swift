//
//  CodableDataStoreEngineUserDefaultsTests.swift
//  CodableDataStoreTests
//
//  Created by Will Taylor on 12/7/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//

import XCTest
@testable import CodableDataStore

class CodableDataStoreEngineBaseTest: XCTestCase {
    
    var codableDataStoreEngine: CodableDataStoreEngineUserDefaults!
    
    // MARK: - Create/Read Tests
    
    /**
     * Ensure that when an item is inserted into the data store, it can be read out with the same key.
     */
    func test_Create_And_Read() {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do {
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
            
            let retrievedObject: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            
            XCTAssertEqual(codable, retrievedObject)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /**
     * Ensure that the create function throws when the same key is inserted more than once.
     */
    func test_Create_Throws_On_Second_Insert() {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do {
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        do {
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
        } catch {
            return
        }
        
        XCTFail("Create should throw an exception on the second insert of the same key.")
    }
    
    // MARK: - Update Tests
    
    /**
     * Ensure that when a pre-existing codable in the data store is updated, the updated value is written to the store.
     */
    func test_Update_Green_Path() {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do {
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // When
        let updatedCodable = TestCodable(name: "fire-at-will", number: 777)
        do {
            try codableDataStoreEngine.update(codableWithID: codableID, withCodable: updatedCodable)
            
            let retrievedObject: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertEqual(updatedCodable, retrievedObject)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /**
     * Ensure that the update method throws when the user attempts to update an object that does not exist inside the
     * data store.
     */
    func test_Update_Throws_When_Item_Does_Not_Exist(){
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        // When updating without an existing entry
        do {
            try codableDataStoreEngine.update(codableWithID: codableID, withCodable: codable)
            
            let _: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
        } catch {
            return
        }
        
        XCTFail("An exception should be thrown when updating an entry that does not exist.")
    }
    
    // MARK: - Update or Create Tests
    
    /**
     * Ensure that when a pre-existing codable in the data store is updated, the updated value is written to the store.
     */
    func test_Update_Or_Create_Green_Path() {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do {
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // When
        let updatedCodable = TestCodable(name: "fire-at-will", number: 777)
        do {
            try codableDataStoreEngine.update(codableWithID: codableID, withCodable: updatedCodable)
            
            let retrievedObject: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertEqual(updatedCodable, retrievedObject)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /**
     * Ensure that the update method inserts the updated object when an update call is made on a key that does not
     * exist in the data store.
     */
    func test_Update_Or_Create_Inserts_When_Item_Does_Not_Exist() {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        // When updating without an existing entry
        do {
            try codableDataStoreEngine.updateOrCreate(codableWithID: codableID, withCodable: codable)
            
            let resultingCodable: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertEqual(codable, resultingCodable)
        } catch {
            XCTFail("The updateOrCreate function should insert the updated object when an update call is made on a key that does not exist in the data store.")
        }
    }
    
    // MARK: - Delete Tests
    
    /**
     * Ensure that deletion works when an item exists in the data store.
     */
    func test_Delete_Works_When_Item_Exists(){
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do{
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
            
            // Ensure that item was written to data store
            try XCTAssertEqual(codable, codableDataStoreEngine.read(withId: codableID))
            
            // When
            try codableDataStoreEngine.delete(codableWithID: codableID, withType: TestCodable.self)
            
            // Then
            let readCodable: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertNil(readCodable)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /**
     * Ensure that deletion does not throw an error when the item does not exist in the data store.
     */
    func test_Delete_Works_When_Item_Does_Not_Exist(){
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let codableID = "qwerty"
        
        do{
            // When
            try codableDataStoreEngine.delete(codableWithID: codableID, withType: TestCodable.self)
            
            // Then
            let readCodable: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertNil(readCodable)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch All IDs Tests
    
    /**
     * Ensure that all IDs can be fetched when there is data in the data store.
     */
    func test_Fetch_All_IDs_With_3_Items() throws{
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let testObject1 = TestCodable(name: "Bill Gates", number: 999)
        let testObject2 = TestCodable(name: "Barack Obama", number: 100)
        let testObject3 = TestCodable(name: "Tim Cook", number: 1)
        
        let id1 = "id1"
        let id2 = "id2"
        let id3 = "id3"
        
        try codableDataStoreEngine.create(withID: id1, codable: testObject1)
        try codableDataStoreEngine.create(withID: id2, codable: testObject2)
        try codableDataStoreEngine.create(withID: id3, codable: testObject3)
        
        // When
        let ids = try codableDataStoreEngine.fetchAllIDs(ofType: TestCodable.self)
        
        // Then
        XCTAssertEqual(3, ids.count)
        XCTAssertTrue(ids.contains(id1))
        XCTAssertTrue(ids.contains(id2))
        XCTAssertTrue(ids.contains(id3))
    }
    
    /**
     * Ensure that fetching all IDs when there are no items in the data store returns a blank array.
     */
    func test_Fetch_All_IDs_With_No_Items() throws{
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        // Nothing
        
        // When
        let ids = try codableDataStoreEngine.fetchAllIDs(ofType: TestCodable.self)
        
        // Then
        XCTAssertEqual(0, ids.count)
    }
    
    // MARK: - Fetch All Entries Tests
    
    /**
     * Ensure that fetching all entries returns a blank dictionary when there are no entries in the data store.
     */
    func test_Fetch_All_Entries_No_Entries() throws {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given nothing
        
        // When
        let entries = try codableDataStoreEngine.fetchAllEntries(ofType: TestCodable.self)
        
        // Then
        XCTAssertEqual(0, entries.count)
    }
    
    /**
     * Ensure that fetching all entries works when there are entries in the data store.
     */
    func test_Fetch_All_Entries_3_Entries() throws {
        guard let codableDataStoreEngine = codableDataStoreEngine else {
            return
        }
        
        // Given
        let testObject1 = TestCodable(name: "Bill Gates", number: 999)
        let testObject2 = TestCodable(name: "Barack Obama", number: 100)
        let testObject3 = TestCodable(name: "Tim Cook", number: 1)
        
        let id1 = "id1"
        let id2 = "id2"
        let id3 = "id3"
        
        try codableDataStoreEngine.create(withID: id1, codable: testObject1)
        try codableDataStoreEngine.create(withID: id2, codable: testObject2)
        try codableDataStoreEngine.create(withID: id3, codable: testObject3)
        
        // When
        let entries = try codableDataStoreEngine.fetchAllEntries(ofType: TestCodable.self)

        // Then
        XCTAssertEqual(3, entries.count)
        XCTAssertEqual(testObject1, entries[id1])
        XCTAssertEqual(testObject2, entries[id2])
        XCTAssertEqual(testObject3, entries[id3])
    }
}
