//
//  CodableDataStoreTests.swift
//  
//
//  Created by Will Taylor on 12/11/19.
//

import XCTest
@testable import CodableDataStore

class CodableDataStoreTests: XCTestCase {
    
    /**
     * Ensure that creating a codable data store works.
     */
    func test_Init(){
        let codableDataStore = CodableDataStore<TestCodable>()
        XCTAssertNotNil(codableDataStore)
    }
}
