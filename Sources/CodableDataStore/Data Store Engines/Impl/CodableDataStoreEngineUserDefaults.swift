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
        
        let dataFromUserDefaults = userDefaults?.data(forKey: id)
        
        if dataFromUserDefaults != nil {
            throw CodableDataStoreError.itemAlreadyExists
        }
        
        userDefaults?.set(data, forKey: id)
        userDefaults?.synchronize()
    }
    
    func read<T>(withId id: String) throws -> T? where T : Decodable, T : Encodable {
        let rawData = userDefaults?.data(forKey: id)
        
        guard let data = rawData else {
            return nil
        }
        
        return dataToCodable(data)
    }
    
    func update<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        
        guard let _ = userDefaults?.data(forKey: id) else {
            throw CodableDataStoreError.itemDoesNotExist
        }
        
        let data = try? codableToData(codable: newCodable)
        userDefaults?.set(data, forKey: id)
        userDefaults?.synchronize()
    }
    
    func updateOrCreate<T: Codable>(codableWithID id: String, withCodable newCodable: T) throws {
        let data = try? codableToData(codable: newCodable)
        userDefaults?.set(data, forKey: id)
        userDefaults?.synchronize()
    }
    
    func delete(codableWithID id: String) throws {
        userDefaults?.removeObject(forKey: id)
        userDefaults?.synchronize()
    }
    
    func fetchAllIDs<T: Codable>(ofType type: T.type) throws -> [String] {
        print("Base ID: HELLO")
        let typedID = getIDWithType(userProvidedID: "HELLO", type: type)
        print("Typed ID: \(typedID)")
        
        return []
    }
    
    func fetchAllEntries<T>() throws -> Dictionary<String, T> where T : Decodable, T : Encodable {
        print("")
        return [:]
    }
    
    // MARK: - Private Helpers
    
    private func getIDWithType<T: Codable>(userProvidedID: String, type: T.Type) -> String {
        let typeString = String(describing: type.self)
        print(typeString)
        return "\(typeString)/\(userProvidedID)"
    }
    
    private func getBaseIDFromTypedID<T: Codable>(typedID: String, type: T.Type) -> String {
        let typeString = String(describing: type.self)
        let range = typedID.index(typedID.startIndex, offsetBy: typeString.count - 1)
        let baseID = typedID[range]
        print("Base ID \(baseID)")
        return "\(baseID)"
    }
    
    private func codableToData<T: Codable>(codable: T) throws -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(codable) {
            return encoded
        }
        return nil
    }
    
    private func dataToCodable<T: Codable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: data) {
            return decoded
        } else {
            return nil
        }
    }
}
