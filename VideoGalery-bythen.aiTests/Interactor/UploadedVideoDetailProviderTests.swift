//
//  UploadedVideoDetailProviderTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class UploadedVideoDetailProviderTests: XCTestCase {

    func testGet_shouldCallRequest() async throws {
        var requestCalled = false
        let sut = UploadedVideoDetailProvider(
            request: { requestCalled = true; return videosResponse() }
        )
        
        _ = try await sut.get()
        
        XCTAssertTrue(requestCalled)
    }
    
    func testGet_returnedValueShouldConvert_ResponseToUploadedVideoDetail() async throws {
        let response = videosResponse()
        let sut = UploadedVideoDetailProvider(
            request: { response }
        )
        
        let result = try await sut.get()
        
        XCTAssertEqual(
            result,
            [.init(publicId: response.resources[0].publicId,
                   secureUrl: URL(string: response.resources[0].secureUrl)!,
                   createdAt: response.resources[0].createdAt),
             .init(publicId: response.resources[1].publicId,
                   secureUrl: URL(string: response.resources[1].secureUrl)!,
                   createdAt: response.resources[1].createdAt)]
        )
    }
    
    func testGet_whenRequestThrewError_shouldThrowError() async throws {
        let sut = UploadedVideoDetailProvider(
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
