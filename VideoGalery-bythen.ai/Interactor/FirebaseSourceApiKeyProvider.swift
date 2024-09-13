//
//  FirebaseSourceApiKeyProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation

struct Keys: Decodable {
    let apiKey: String
    let apiSecret: String
}

protocol RemoteSourceApiKeyProvider {
    var key: () async throws  -> Keys { get }
}

struct FirebaseSourceApiKeyProvider: RemoteSourceApiKeyProvider {
    typealias CollectionName = String
    
    let key: () async throws -> Keys
    
    init(getKey: @escaping (CollectionName) async throws -> Keys) {
        key = {
            var retryCount = 0
            repeat {
                do {
                    return try await getKey("auth_keys")
                } catch {
                    retryCount += 1
                    if retryCount < 3 {
                        try await Task.sleep(nanoseconds: 500_000_000)
                    } else {
                        throw error
                    }
                }
            } while true
        }
    }
}

extension FirebaseSourceApiKeyProvider {
    static func make() -> Self {
        FirebaseSourceApiKeyProvider(getKey: FirebaseDocumentProvider.getDocument)
    }
}
