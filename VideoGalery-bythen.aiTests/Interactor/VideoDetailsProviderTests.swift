//
//  VideoDetailsProvider.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class VideoDetailsProviderTests: XCTestCase {

    func testGet_shouldCallRequest() async throws {
        var requestCalled = false
        let sut = VideoDetailsProvider(
            request: { requestCalled = true; return videosResponse() }
        )
        
        _ = try await sut.get()
        
        XCTAssertTrue(requestCalled)
    }
    
    func testGet_returnedValueShouldConvert_ResponseToUploadedVideoDetail() async throws {
        let response = videosResponse()
        let sut = VideoDetailsProvider(
            request: { response }
        )
        
        let result = try await sut.get()
        
        XCTAssertEqual(result[0].publicId, response.resources[0].publicId)
        XCTAssertEqual(result[0].secureUrl, URL(string: response.resources[0].secureUrl)!)
        XCTAssertEqual(result[0].createdAt, response.resources[0].createdAt)
        XCTAssertEqual(result[1].publicId, response.resources[1].publicId)
        XCTAssertEqual(result[1].secureUrl, URL(string: response.resources[1].secureUrl)!)
        XCTAssertEqual(result[1].createdAt, response.resources[1].createdAt)
    }
    
    func testGet_whenRequestThrewError_shouldThrowError() async throws {
        let sut = VideoDetailsProvider(
            request: { throw ErrorInTest.sample }
        )
        
        await XCTAssertThrowsError(try await sut.get(), expectedError: ErrorInTest.sample)
    }
}

private func videosResponse() -> ResourcesResponse<[VideoResponse]> {
    .init(
        resources: [.init(publicId: .random(),
                          secureUrl: .random(),
                          createdAt: .random()),
                    .init(publicId: .random(),
                          secureUrl: .random(),
                          createdAt: .random())]
    )
}
