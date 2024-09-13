//
//  UploadedVideoDetailProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

struct UploadedVideoDetail: Equatable {
    let publicId: String
    let secureUrl: String
    let createdAt: String
}

struct UploadedVideoDetailProvider {
    private let request: () async throws -> ResourcesResponse<[VideoResponse]>
    
    init(request: @escaping () async throws -> ResourcesResponse<[VideoResponse]>) {
        self.request = request
    }
    
    func get() async throws -> [UploadedVideoDetail] {
        let response = try await request()
        return response.resources.map {
            .init(publicId: $0.publicId, secureUrl: $0.secureUrl, createdAt: $0.createdAt)
        }
    }
}
