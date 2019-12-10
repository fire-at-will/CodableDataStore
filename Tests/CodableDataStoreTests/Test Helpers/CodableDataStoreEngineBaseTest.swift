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
    func test_Update_Green_Path(){
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
    func test_Update_Or_Create_Green_Path(){
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
    func test_Update_Or_Create_Inserts_When_Item_Does_Not_Exist(){
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
    func test_Delete_Works_When_Item_Exists(){
        // Given
        let codable = TestCodable(name: "A name", number: 64)
        let codableID = "qwerty"
        
        do{
            try codableDataStoreEngine.create(withID: codableID, codable: codable)
            
            // Ensure that item was written to data store
            try XCTAssertEqual(codable, codableDataStoreEngine.read(withId: codableID))
            
            // When
            try codableDataStoreEngine.delete(codableWithID: codableID)
            
            // Then
            let readCodable: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertNil(readCodable)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_Delete_Works_When_Item_Does_Not_Exist(){
        // Given
        let codableID = "qwerty"
        
        do{
            // When
            try codableDataStoreEngine.delete(codableWithID: codableID)
            
            // Then
            let readCodable: TestCodable? = try codableDataStoreEngine.read(withId: codableID)
            XCTAssertNil(readCodable)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
