//
//  KeychainStoreIntegrationTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/13/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class KeychainStoreIntegrationTests: XCTestCase {
    
    override func setUpWithError() throws {
        removeApiKeyFromKeychain()
    }

    func testGet_thenSave_shouldRetrieveCorrectValue() throws {
        var sut = KeychainStore()
        let key = String.random()
        var value = String.random()
        
        XCTAssertNil(sut[key])
        
        sut[key] = value
        XCTAssertEqual(sut[key], value)
        
        value = String.random()
        sut[key] = value
        XCTAssertEqual(sut[key], value)
    }
}
