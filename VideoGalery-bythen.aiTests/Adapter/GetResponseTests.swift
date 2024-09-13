//
//  GetResponseTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class GetResponseTests: XCTestCase {

    func testFetch_shouldPassCorrectParameter() async throws {
        var getDataCalled = false
        var passedData: Data?
        let data = Data(count: .random())
        let sut = GetResponse.make(
            getData: { getDataCalled = true; return data },
            decoder: { passedData = $0; return StubResponse() }
        )
        
        _ = try await sut.fetch()
        
        XCTAssertTrue(getDataCalled)
        XCTAssertEqual(passedData, data)
    }
    
    func testFetch_shouldReturnResponseFromDecoder() async throws {
        let response = StubResponse()
        let sut = GetResponse.make(decoder: { _ in response })
        
        let result = try await sut.fetch()
        
        XCTAssertEqual(result, response)
    }
    
    func testFetch_whenGetDataThrewError_shouldThrowError() async throws {
        let sut = GetResponse.make(getData: { throw ErrorInTest.sample })
        
        await XCTAssertThrowsError(
            try await sut.fetch(),
            expectedError: ErrorInTest.sample
        )
    }
    
    func testFetch_whenDecoderThrewError_shouldThrowError() async throws {
        let sut = GetResponse.make(decoder: { _ in throw ErrorInTest.sample })
        
        await XCTAssertThrowsError(
            try await sut.fetch(),
            expectedError: ErrorInTest.sample
        )
    }
}

extension GetResponse {
    static func make(
        getData: @escaping () async throws -> Data = { Data() },
        decoder: @escaping (Data) throws -> T = { _ in StubResponse() }
    ) -> Self {
        .init(getData: getData, decoder: decoder)
    }
}

private struct StubResponse: Decodable, Equatable {
    let identifier: UUID
    
    init() { identifier = UUID() }
}
