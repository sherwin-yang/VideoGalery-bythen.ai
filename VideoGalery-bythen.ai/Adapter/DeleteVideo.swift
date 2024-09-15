//
//  DeleteVideo.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation

struct DeleteVideo {
    private let getAuthKey: () async throws -> ApiKey
    private let delete: (URLRequest) async throws -> Data
    
    init(
        getAuthKey: @escaping () async throws -> ApiKey,
        delete: @escaping (URLRequest) async throws -> Data
    ) {
        self.getAuthKey = getAuthKey
        self.delete = delete
    }
    
    func delete(publicId: String) {
        Task {
            guard let authKey = try? await getAuthKey(),
                  let intApiKey = Int(authKey.apiKey),
                  let encodedAuth = "\(intApiKey):\(authKey.apiSecret)".data(using: .utf8)?.base64EncodedString(),
                  let url = try? CloudinaryURLBuilder(
                    path: "resources/video/upload",
                    param: ["public_ids": publicId]
                  ).build()
            else { return }
            
            let urlRequest = APIURLRequest(url: url)
                .setMethod(.DELETE)
                .setHeader(["Authorization": "Basic \(encodedAuth)"])
                .build()
            
            _ = try await delete(urlRequest)
        }
    }
}

extension DeleteVideo {
    static func make() -> Self {
        .init(getAuthKey: ApiKeyManager.make().get, delete: HTTPRequest.makeRequest)
    }
}
