//
//  UploadedVideoDetailProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

struct UploadedVideoDetail: Equatable, Identifiable, Hashable {
    var id = UUID()
    let publicId: String
    let secureUrl: URL
    let createdAt: String
}

struct UploadedVideoDetailProvider {
    private let request: () async throws -> ResourcesResponse<[VideoResponse]>
    
    init(request: @escaping () async throws -> ResourcesResponse<[VideoResponse]>) {
        self.request = request
    }
    
    func get() async throws -> [UploadedVideoDetail] {
        let response = try await request()
        var uploadedVideoDetail: [UploadedVideoDetail] = []
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

extension UploadedVideoDetailProvider {
    static func make() -> Self{
        return .init(
            request: GetResponse(
                getData: GetVideo(
                    getAuthKey: ApiKeyManager.make().get,
                    getData: HTTPRequest.get
                ).data,
                decoder: ResourcesResponse<[VideoResponse]>.decode
            ).fetch
        )
    }
}
