//
//  CodableDataStore.swift
//  CodableDataStore
//
//  Created by Will Taylor on 12/7/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//

import Foundation
class CodableDataStore<T: Codable> {
    
    /// Engine used to
    private var engine: CodableDataStoreEngine?
    
    // MARK: - Initializers
    /**
     * Initializes a new CodableDataStore object.
     *
     * By default, the data store uses _User Defaults_ under the hood,
     * but this behavior can be overriden by providing a custom `CodableDataStoreEngine` object.
     *
     * - Author: Will Taylor
     * - Date: 12/7/2019
     *
     * - Parameters:
     *      - engine: The DAO object that writes the codables to the data store. Defaults to using _User Defaults_.
     */
    init(engine: CodableDataStoreEngine = CodableDataStoreEngineUserDefaults()){
        self.engine = engine
    }
   
    // MARK - Public API
   /**
    * Persists a new codable in the data store.
    *
    * - Author: Will Taylor
    * - Date: 12/7/2019
    *
    * - Parameters:
    *      - id: The ID of the new codable.
     *     - codable: The new codable to persist.
    *
    * - Throws: If the create action fails.
    */
    func create<T: Codable>(withID id: String, codable: T) throws {
        try engine?.create(withID: id, codable: codable)
    }
    
    /**
     * Reads a codable from the data store.
     *
     * - Author: Will Taylor
     * - Date: 12/7/2019
     *
     * - Parameters:
     *      - id: The ID of the codable to be read.
     *
     * - Returns:
     *      - The codable object, if found.
     */
    func read(withId id: String) throws -> T? {
        try engine?.read(withId: id)
    }
    
    /**
     * Update a codable with the given ID.
     *
     * - Author: Will Taylor
     * - Date: 12/7/2019
     *
     * - Parameters:
     *      - id: The ID of the codable to update.
     *      - newCodable: The new value to overwrite with.
     *
     * - Throws: If an IO error occurs of if the provided ID is not found.
     */
    func update<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        try engine?.update(codableWithID: id, withCodable: newCodable)
    }
    
    /**
     * Update a codable with the given ID.
     *
     * If the given ID is not found, the provided codable is persisted with the provided ID.
     *
     * - Author: Will Taylor
     * - Date: 12/7/2019
     *
     * - Parameters:
     *      - id: The ID of the codable to update.
     *      - newCodable: The new value to overwrite with.
     *
     * - Throws: If an IO error occurs.
     */
    func updateOrInsert<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        try engine?.updateOrCreate(codableWithID: id, withCodable: newCodable)
    }
    
    /**
     * Delete the codable from the data store.
     *
     * If the given ID is not found, nothing happens.
     *
     * - Author: Will Taylor
     * - Date: 12/7/2019
     *
     * - Parameters:
     *      - id: The ID of the codable to delete.
     */
    func delete(codableWithID id: String) throws {
        try engine?.delete(codableWithID: id)
    }
}
