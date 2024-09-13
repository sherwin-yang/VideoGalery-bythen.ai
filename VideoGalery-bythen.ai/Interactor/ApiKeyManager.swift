//
//  ApiKeyManager.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation
import Combine

enum GetApiKeyError: Error {
    case failToRetrieve
}

struct ApiKeyManager {
    private var secureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManagerProtocol
    private let getRemoteSourceApiKey: () async throws -> Keys
    
    init(
        secureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManagerProtocol,
        getRemoteSourceApiKey: @escaping () async throws -> Keys
    ) {
        self.secureLocalSourceApiKeyManager = secureLocalSourceApiKeyManager
        self.getRemoteSourceApiKey = getRemoteSourceApiKey
    }
    
    mutating func get() async throws -> ApiKey {
        if let key = secureLocalSourceApiKeyManager.get() { return key }
        
        let remoteSourceKey = try await getRemoteSourceApiKey()
        secureLocalSourceApiKeyManager.save(apiKey: remoteSourceKey.apiKey, apiSecret: remoteSourceKey.apiSecret)
        
        guard let localSourceKey = secureLocalSourceApiKeyManager.get()
        else { throw GetApiKeyError.failToRetrieve }
        
        return localSourceKey
    }
}
