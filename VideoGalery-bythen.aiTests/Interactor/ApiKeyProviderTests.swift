//
//  ApiKeyProviderTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/13/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class ApiKeyProviderTests: XCTestCase {
    
    func testGet_shouldCallGetFromSecureStorage() {
        let secureStoreMock = SecureStoreMock(fillKeys: true)
        let sut = ApiKeyProvider(secureStorage: secureStoreMock)
        
        _ = sut.get()
        
        XCTAssertTrue(secureStoreMock.getWithKeys.contains("apiKey"))
        XCTAssertTrue(secureStoreMock.getWithKeys.contains("apiSecret"))
    }
    
    func testGet_shouldReturnNil_whenStorageReturnNil() {
        let secureStoreMock = SecureStoreMock(fillKeys: false)
        let sut = ApiKeyProvider(secureStorage: secureStoreMock)
        
        XCTAssertNil(sut.get())
    }
    
    func testGet_shouldReturnApiKeyFromStorage() {
        let secureStoreMock = SecureStoreMock(fillKeys: true)
        let sut = ApiKeyProvider(secureStorage: secureStoreMock)
        
        XCTAssertEqual(sut.get(),
                       ApiKey(apiKey: secureStoreMock.apiKey!, 
                              apiSecret: secureStoreMock.apiSecret!))
    }
    
    func testSave() {
        let secureStoreMock = SecureStoreMock()
        var sut = ApiKeyProvider(secureStorage: secureStoreMock)
        
        let apiKey = String.random()
        let apiSecret = String.random()
        sut.save(apiKey: apiKey, apiSecret: apiSecret)
        
        XCTAssertTrue(secureStoreMock.saveWithKeys.contains("apiKey"))
        XCTAssertTrue(secureStoreMock.saveWithKeys.contains("apiSecret"))
        XCTAssertTrue(secureStoreMock.savedValues.contains(apiKey))
        XCTAssertTrue(secureStoreMock.savedValues.contains(apiSecret))
    }
    
}

private final class SecureStoreMock: SecureStoreProtocol {
    private var storage: [String: String]
    init(fillKeys: Bool = false) {
        storage = fillKeys ? ["apiKey": String.random(), "apiSecret": String.random()] : [:]
    }
    
    var apiKey: String? { storage["apiKey"] }
    var apiSecret: String? { storage["apiSecret"] }
    
    var getWithKeys: [String] = []
    var saveWithKeys: [String] = []
    var savedValues: [String] { Array(storage.values) }
    subscript(key: String) -> String? {
        get {
            getWithKeys.append(key)
            return storage[key]
        }
        set {
            saveWithKeys.append(key)
            storage[key] = newValue
        }
    }
}
