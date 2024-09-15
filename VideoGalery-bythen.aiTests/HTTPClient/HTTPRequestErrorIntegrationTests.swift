//
//  HTTPRequestErrorIntegrationTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/12/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class HTTPRequestErrorIntegrationTests: XCTestCase {

    func testGetRequest_withInvalidURLRequest_shouldThrowError() async {
        await XCTAssertThrowsError(
            try await HTTPRequest.makeRequest(urlRequest: URLRequest(url: URL(string: "error_url")!)),
            useThisOrAddAssertion: { XCTAssertNotNil($0, "An error should've been thrown, but none was found") }
        )
    }
    
    func testGetRequest_withValidURLRequest_butWithFailureResponse_shouldThrowError() async {
        // url isn't provided with required Authentication
        let url = URL(string: "https://api.cloudinary.com/v1_1/dk3lhojel/resources/video")!
        
        await XCTAssertThrowsError(
            try await HTTPRequest.makeRequest(urlRequest: URLRequest(url: url)),
            expectedError: URLError(.badServerResponse),
            failMessage: "Should've thrown an error"
        )
    }
}
