//
//  ApiKeyProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation
import Combine

enum GetApiKeyError: Error {
    case failToRetrieve
}

final class ApiKeyProvider {
    private var secureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManagerProtocol
    private let getRemoteSourceApiKey: () async throws -> Keys
    
    init(
        secureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManagerProtocol,
        getRemoteSourceApiKey: @escaping () async throws -> Keys
    ) {
        self.secureLocalSourceApiKeyManager = secureLocalSourceApiKeyManager
        self.getRemoteSourceApiKey = getRemoteSourceApiKey
    }
    
    func get() async throws -> ApiKey {
        if let key = secureLocalSourceApiKeyManager.get() { return key }
        
        let remoteSourceKey = try await getRemoteSourceApiKey()
        secureLocalSourceApiKeyManager.save(apiKey: remoteSourceKey.apiKey, apiSecret: remoteSourceKey.apiSecret)
        
        guard let localSourceKey = secureLocalSourceApiKeyManager.get()
        else { throw GetApiKeyError.failToRetrieve }
        
        return localSourceKey
    }
}

extension ApiKeyProvider {
    static func make() -> Self {
        .init(secureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManager.make(),
              getRemoteSourceApiKey: FirebaseSourceApiKeyProvider.make().key)
    }
}
