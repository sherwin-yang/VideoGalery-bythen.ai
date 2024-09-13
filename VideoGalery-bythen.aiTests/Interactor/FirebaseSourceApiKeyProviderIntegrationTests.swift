//
//  FirebaseSourceApiKeyProviderIntegrationTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/13/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class FirebaseSourceApiKeyProviderIntegrationTests: XCTestCase {

    func testGetKey_notThrowingError() {
        let sut = FirebaseSourceApiKeyProvider(
            getKey: FirebaseDocumentProvider.getDocument
        )
        XCTAssertNoThrow(sut.key)
    }
}
