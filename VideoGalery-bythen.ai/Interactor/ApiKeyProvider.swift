//
//  ApiKeyProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation

struct ApiKey: Equatable {
    let apiKey: String
    let apiSecret: String
}

protocol ApiKeyProviderProtocol {
    func get() -> ApiKey?
    mutating func save(apiKey: String, apiSecret: String)
}

struct ApiKeyProvider: ApiKeyProviderProtocol {
    
    private enum KeychainKeys: String {
        case apiKey
        case apiSecret
    }
    
    var secureStorage: SecureStoreProtocol
    
    init(secureStorage: SecureStoreProtocol) {
        self.secureStorage = secureStorage
    }
    
    func get() -> ApiKey? {
        guard let apiKey = secureStorage[KeychainKeys.apiKey.rawValue],
              let apiSecret = secureStorage[KeychainKeys.apiSecret.rawValue]
        else { return nil }
        
        return ApiKey(apiKey: apiKey, apiSecret: apiSecret)
    }
    
    mutating func save(apiKey: String, apiSecret: String) {
        secureStorage[KeychainKeys.apiKey.rawValue] = apiKey
        secureStorage[KeychainKeys.apiSecret.rawValue] = apiSecret
    }
}
