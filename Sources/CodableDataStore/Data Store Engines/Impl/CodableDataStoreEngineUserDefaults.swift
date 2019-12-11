//
//  CodableDataStoreEngineUserDefaults.swift
//  CodableDataStore
//
//  Created by Will Taylor on 12/7/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//

import Foundation
class CodableDataStoreEngineUserDefaults: CodableDataStoreEngine {
    
    
    private var userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults = UserDefaults.standard){
        self.userDefaults = userDefaults
    }
    
    func create<T: Codable>(withID id: String, codable: T) throws {
        let data = try? codableToData(codable: codable)
        let internalID = generateInternalID(fromUserProvidedID: id, type: T.self)
        
        let dataFromUserDefaults = userDefaults?.data(forKey: internalID)
        
        if dataFromUserDefaults != nil {
            throw CodableDataStoreError.itemAlreadyExists
        }
        
        userDefaults?.set(data, forKey: internalID)
        userDefaults?.synchronize()
    }
    
    func read<T>(withId id: String) throws -> T? where T : Decodable, T : Encodable {
        let internalID = generateInternalID(fromUserProvidedID: id, type: T.self)
        let rawData = userDefaults?.data(forKey: internalID)
        
        guard let data = rawData else {
            return nil
        }
        
        return dataToCodable(data)
    }
    
    func update<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        let internalID = generateInternalID(fromUserProvidedID: id, type: T.self)
        
        guard let _ = userDefaults?.data(forKey: internalID) else {
            throw CodableDataStoreError.itemDoesNotExist
        }
        
        let data = try? codableToData(codable: newCodable)
        userDefaults?.set(data, forKey: internalID)
        userDefaults?.synchronize()
    }
    
    func updateOrCreate<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        let internalID = generateInternalID(fromUserProvidedID: id, type: T.self)
        let data = try? codableToData(codable: newCodable)
        userDefaults?.set(data, forKey: internalID)
        userDefaults?.synchronize()
    }
    
    func delete<T: Codable>(codableWithID id: String, withType: T.Type) throws {
        let internalID = generateInternalID(fromUserProvidedID: id, type: T.self)
        userDefaults?.removeObject(forKey: internalID)
        userDefaults?.synchronize()
    }
    
    func fetchAllIDs<T: Codable>(ofType type: T.Type) throws -> Set<String> {
        let keysInDataStore: [String] = userDefaults?.dictionaryRepresentation().keys.map({key in return key}) ?? []
        var allIDs: Set<String> = Set([])
        
        for key: String in keysInDataStore {
            if key.starts(with: String(describing: type)) {
                allIDs.insert(
                    getBaseIDFromTypedID(typedID: key, type: type)
                )
            }
        }
        
        return allIDs
    }

    func fetchAllEntries<T: Codable>(ofType type: T.Type) throws -> [String: T?] {
        var entries: [String: T?] = [:]
        
        // Get raw data from User Defaults
        let rawEntries = userDefaults?.dictionaryRepresentation().filter({ entry in
            return entry.key.starts(with: String(describing: type))
        }) ?? []
        
        // Transform the raw data into data that the user can interpret
        for entry: (key: String, value: Any) in rawEntries {
            let userProvidedID = getBaseIDFromTypedID(typedID: entry.key, type: type)
            let codable: T? = dataToCodable(entry.value as? Data)
            
            entries[userProvidedID] = codable
        }
        
        return entries
    }
    
    // MARK: - Private Helpers
    
    private func generateInternalID<T: Codable>(fromUserProvidedID userProvidedID: String, type: T.Type) -> String {
        let typeString = String(describing: type.self)
        return "\(typeString)/\(userProvidedID)"
    }
    
    private func getBaseIDFromTypedID<T: Codable>(typedID: String, type: T.Type) -> String {
        let typeString = String(describing: type.self)
        let endIndex = typedID.index(typedID.startIndex, offsetBy: typeString.count + 1)
        let baseID = typedID[endIndex...]
        return String(baseID)
    }
    
    private func codableToData<T: Codable>(codable: T) throws -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(codable) {
            return encoded
        }
        return nil
    }
    
    private func dataToCodable<T: Codable>(_ data: Data?) -> T? {
        guard let data = data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: data) {
            return decoded
        } else {
            return nil
        }
    }
}
