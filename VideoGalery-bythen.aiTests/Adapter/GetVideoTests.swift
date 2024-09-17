//
//  GetVideoTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class GetVideoTests: XCTestCase {

    func testGetData_passCorrectParameter() async throws {
        let apiKey = ApiKey(apiKey: "\(Int.random())", apiSecret: .random())
        var getAuthKeyCalled = false
        var urlRequest: URLRequest?
        let sut = GetVideo.makeSUT(
            getAuthKey: {
                getAuthKeyCalled = true
                return apiKey
            },
            getData: {
                urlRequest = $0
                return Data()
            }
        )
        
        _ = try await sut.data()
        
        let encodedAuth = "\(Int(apiKey.apiKey)!):\(apiKey.apiSecret)"
            .data(using: .utf8)!
            .base64EncodedString()
        
        XCTAssertTrue(getAuthKeyCalled)
        XCTAssertEqual(urlRequest?.httpMethod, HTTPRequestMethod.GET.rawValue)
        XCTAssertEqual(urlRequest?.url?.absoluteString,
                       "https://api.cloudinary.com/v1_1/dk3lhojel/resources/video")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields,
                       ["Authorization": "Basic \(encodedAuth)"])
    }
    
    func testGetData_returnDataFromGetData() async throws {
        let data = Data(count: .random())
        let sut = GetVideo.makeSUT(getData: { _ in data })
        
        let result = try await sut.data()
        XCTAssertEqual(result, data)
    }
    
    func testGetData_whenGetAuthKeyThrewError_shouldThrowError() async {
        let sut = GetVideo.makeSUT(getAuthKey: { throw ErrorInTest.sample })
        
        await XCTAssertThrowsError(
            try await sut.data(),
            expectedError: ErrorInTest.sample
        )
    }
    
    func testGetData_whenGetDataThrewError_shouldThrowError() async {
        let sut = GetVideo.makeSUT(getData: { _ in throw ErrorInTest.sample })
        
        await XCTAssertThrowsError(
            try await sut.data(),
            expectedError: ErrorInTest.sample
        )
    }

}

private extension GetVideo {
    static func makeSUT(
        getAuthKey: @escaping () async throws -> ApiKey
        = { .init(apiKey: "\(Int.random())", apiSecret: .random()) },
        getData: @escaping (URLRequest) async throws -> Data
        = { _ in Data() }
    ) -> Self {
        .init(getAuthKey: getAuthKey, getData: getData)
    }
}
