//
//  RemoteSourceApiKeyProviderTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/13/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class RemoteSourceApiKeyProviderTests: XCTestCase {

    func testCallKey_ShouldCallGetKeyWithCorrectArgument() async throws {
        var getKeyWithCollectionName: String?
        let sut = FirebaseSourceApiKeyProvider {
            getKeyWithCollectionName = $0
            return Keys.dummy()
        }
        
        _ = try await sut.key()
        
        XCTAssertEqual(getKeyWithCollectionName, "auth_keys")
    }
}

private extension Keys {
    static func dummy() -> Self {
        Keys(apiKey: String.random(), apiSecret: String.random())
    }
}
