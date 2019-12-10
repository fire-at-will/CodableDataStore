//
//  CodableDataStoreError.swift
//  CodableDataStore
//
//  Created by Will Taylor on 12/7/19.
//  Copyright © 2019 Will Taylor. All rights reserved.
//

import Foundation
public enum CodableDataStoreError: Error {
    case itemAlreadyExists
    case itemDoesNotExist
}

extension CodableDataStoreError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .itemAlreadyExists:
            return NSLocalizedString("The codable already exists in the data store.", comment: "")
        case .itemDoesNotExist:
            return NSLocalizedString("The codable does not exist in the data store.", comment: "")
        }
        
        
    }
    
    public var failureReason: String? {
        switch self {
        case .itemAlreadyExists:
            return NSLocalizedString("The codable already exists in the data store.", comment: "")
        case .itemDoesNotExist:
            return NSLocalizedString("The codable does not exist in the data store.", comment: "")
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .itemAlreadyExists:
            return NSLocalizedString("Try removing the codable from the data store and trying again. Alternatively, consider using an update operation.", comment: "")
        case .itemDoesNotExist:
            return NSLocalizedString("The codable already exists in the data store.", comment: "")
        }
    }
}
