//
//  GetVideoIntegrationTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class GetVideoIntegrationTests: XCTestCase {
    
    override func setUpWithError() throws {
        removeApiKeyFromKeychain()
    }

    func testGetVideo() async throws {
        let sut = GetResponse(
            getData: GetVideo(
                getAuthKey: ApiKeyManager.make().get,
                getData: HTTPRequest.get
            ).data,
            decoder: ResourcesResponse<[VideoResponse]>.decode
        )
        
        do {
            _ = try await sut.fetch()
        } catch {
            XCTFail("Fetch data should've succeeded. Error: \(error)")
        }
    }
}
