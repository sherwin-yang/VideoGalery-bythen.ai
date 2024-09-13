//
//  GetVideo.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

struct VideoResponse: Decodable {
    let publicId: String
    let secureUrl: String
    let createdAt: String
}

enum GetVideoError: Error {
    case failedEncodingAuthKeys
}

struct GetVideo {
    private let getAuthKey: () async throws -> ApiKey
    private let getData: (URLRequest) async throws -> Data
    
    init(
        getAuthKey: @escaping () async throws -> ApiKey,
        getData: @escaping (URLRequest) async throws -> Data
    ) {
        self.getAuthKey = getAuthKey
        self.getData = getData
    }
    
    func data() async throws -> Data {
        let authKey = try await getAuthKey()
        let url = try CloudinaryURLBuilder(path: "resources/video").build()
        
        guard let intApiKey = Int(authKey.apiKey),
              let encodedAuth = "\(intApiKey):\(authKey.apiSecret)"
            .data(using: .utf8)?
            .base64EncodedString()
        else { throw GetVideoError.failedEncodingAuthKeys }
        
        return try await getData(
            APIURLRequest(url: url)
                .setMethod(.GET)
                .setHeader(["Authorization": "Basic \(encodedAuth)"])
                .build()
        )
    }
}
