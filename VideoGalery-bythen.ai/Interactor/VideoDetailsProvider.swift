//
//  VideoDetailsProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

struct VideoDetail: Equatable, Identifiable, Hashable {
    var id = UUID()
    let publicId: String
    let secureUrl: URL
    let createdAt: String
}

struct VideoDetailsProvider {
    private let request: () async throws -> ResourcesResponse<[VideoResponse]>
    
    init(request: @escaping () async throws -> ResourcesResponse<[VideoResponse]>) {
        self.request = request
    }
    
    func get() async throws -> [VideoDetail] {
        let response = try await request()
        var uploadedVideoDetail: [VideoDetail] = []
        response.resources.forEach {
            if let secureUrl = URL(string: $0.secureUrl) {
                uploadedVideoDetail.append(
                    .init(publicId: $0.publicId, 
                          secureUrl: secureUrl,
                          createdAt: $0.createdAt)
                )
            }
        }
        
        return uploadedVideoDetail
    }
}

extension VideoDetailsProvider {
    static func make() -> Self{
        return .init(
            request: GetResponse(
                getData: GetVideo(
                    getAuthKey: ApiKeyProvider.make().get,
                    getData: HTTPRequest.makeRequest
                ).data,
                decoder: ResourcesResponse<[VideoResponse]>.decode
            ).fetch
        )
    }
}
