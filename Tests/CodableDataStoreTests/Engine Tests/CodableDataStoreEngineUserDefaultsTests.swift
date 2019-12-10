//
//  Test.swift
//  CodableDataStoreTests
//
//  Created by Will Taylor on 12/8/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//
//  Test the CodableDataStoreEngineUserDefaults class by extending the CodableDataStoreEngineBaseTest class.
//

import XCTest
@testable import CodableDataStore

class CodableDataStoreEngineUserDefaultsTests: CodableDataStoreEngineBaseTest {
    private var userDefaults: UserDefaults!

    // Provide the CodableDataStoreEngineBaseTest class with an engine to test
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
        
        codableDataStoreEngine = CodableDataStoreEngineUserDefaults(userDefaults: userDefaults)
    }
}
