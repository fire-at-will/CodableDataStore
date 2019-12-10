//
//  CodableDataStoreEngine.swift
//  CodableDataStore
//
//  Created by Will Taylor on 12/7/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//
//  Defines the interface of an engine that can read & write codables
//  to a persistent data store.
//

import Foundation
protocol CodableDataStoreEngine {
    
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
    func create<T: Codable>(withID id: String, codable: T) throws
    
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
    func read<T: Codable>(withId id: String) throws -> T?
    
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
     * - Throws: If the provided ID is not found.
     */
    func update<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws
    
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
     */
    func updateOrCreate<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws
    
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
    func delete(codableWithID id: String) throws
    
    /**
     * List all IDs in the data store that are associated with this codable.
     *
     * - Author: Will Taylor
     * - Date: 12/8/2019
     *
     * - Returns: A list of all IDs
     */
    func fetchAllIDs() -> [String] throws
    
    /**
     * Retrieves a dictionary containing all IDs and values in the data store for the codable type.
     *
     * - Author: Will Taylor
     * - Date: 12/8/2019
     *
     * - Returns: A dictionary containing the keys and values for the codables contained in the data store.
     */
    func fetchAllEntries<T: Codable>() throws -> Dictionary<String, T>
}
