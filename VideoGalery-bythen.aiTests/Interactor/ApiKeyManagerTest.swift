//
//  ApiKeyManagerTest.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/13/24.
//

import XCTest
import Combine

@testable import VideoGalery_bythen_ai

final class ApiKeyManagerTest: XCTestCase {

    func testGetKey_whenApiKeyIsExistInLocal_shouldReturnKeyFromLocalSource() async throws {
        func test(fillApiKey: Bool, line: UInt = #line) async throws {
            let secureLocalSourceApiKeyManagerMock = SecureLocalSourceApiKeyManagerMock(apiKeyExist: fillApiKey)
            var getRemoteSourceApiKeyCalled = false
            let sut = ApiKeyManager(
                secureLocalSourceApiKeyManager: secureLocalSourceApiKeyManagerMock,
                getRemoteSourceApiKey: {
                    getRemoteSourceApiKeyCalled = true
                    return Keys(apiKey: .random(), apiSecret: .random())
                }
            )
            
            let key = try await sut.get()
            
            XCTAssertEqual(key, secureLocalSourceApiKeyManagerMock.get(), line: line)
            XCTAssertEqual(getRemoteSourceApiKeyCalled, !fillApiKey, line: line)
        }
        
        try await test(fillApiKey: true)
        try await test(fillApiKey: false)
    }
    
    func testGetKey_whenApiKeyIsNotExistInLocal_shouldDoActionsSequentially() async throws {
        var actions: [Actions] = []
        
        let secureLocalSourceApiKeyManagerMock = SecureLocalSourceApiKeyManagerMock(apiKeyExist: false)
        let remoteSourceApiKey = Keys(apiKey: .random(), apiSecret: .random())
        let sut = ApiKeyManager(
            secureLocalSourceApiKeyManager: secureLocalSourceApiKeyManagerMock,
            getRemoteSourceApiKey: {
                actions.append(.getFromRemote)
                return remoteSourceApiKey
            }
        )
        
        let cancellable1 = secureLocalSourceApiKeyManagerMock
            .actionPublisher
            .sink { actions.append($0) }
        defer { cancellable1.cancel() }
        
        _ = try await sut.get()

        XCTAssertEqual(actions, [.getFromLocal, .getFromRemote, .savedToLocal, .getFromLocal])
    }
    
    func testGetKey_shouldSaveKeyFromRemoteToLocal() async throws {
        let secureLocalSourceApiKeyManagerMock = SecureLocalSourceApiKeyManagerMock(apiKeyExist: false)
        let remoteSourceApiKey = Keys(apiKey: .random(), apiSecret: .random())
        let sut = ApiKeyManager(
            secureLocalSourceApiKeyManager: secureLocalSourceApiKeyManagerMock,
            getRemoteSourceApiKey: { remoteSourceApiKey }
        )
        
        _ = try await sut.get()
        
        XCTAssertEqual(secureLocalSourceApiKeyManagerMock.savedApiKey, remoteSourceApiKey.apiKey)
        XCTAssertEqual(secureLocalSourceApiKeyManagerMock.savedApiSecret, remoteSourceApiKey.apiSecret)
    }
    
    func testGetKey_whenLocalSourceNeverReturnKey() async throws {
        let sut = ApiKeyManager(
            secureLocalSourceApiKeyManager: AlwaysNilApiKeySecureLocalSourceApiKeyManager(),
            getRemoteSourceApiKey: { .init(apiKey: .random(), apiSecret: .random()) }
        )
        
        await XCTAssertThrowsError(try await sut.get(), expectedError: GetApiKeyError.failToRetrieve)
    }
}

private enum Actions {
    case savedToLocal
    case getFromLocal
    case getFromRemote
}

private final class SecureLocalSourceApiKeyManagerMock: SecureLocalSourceApiKeyManagerProtocol {
    private let action = PassthroughSubject<Actions, Never>()
    var actionPublisher: AnyPublisher<Actions, Never> { action.eraseToAnyPublisher() }
    
    private let apiKey: ApiKey?
    init(apiKeyExist: Bool) {
        apiKey = apiKeyExist
        ? .init(apiKey: .random(), apiSecret: .random())
        : nil
    }
    
    func get() -> ApiKey? {
        action.send(.getFromLocal)
        return savedApiKey == nil && savedApiSecret == nil
        ? apiKey
        : .init(apiKey: savedApiKey!, apiSecret: savedApiSecret!)
    }
    
    var savedApiKey: String?
    var savedApiSecret: String?
    func save(apiKey: String, apiSecret: String) {
        action.send(.savedToLocal)
        savedApiKey = apiKey
        savedApiSecret = apiSecret
    }
}

private struct AlwaysNilApiKeySecureLocalSourceApiKeyManager: SecureLocalSourceApiKeyManagerProtocol {
    func get() -> ApiKey? { nil }
    func save(apiKey: String, apiSecret: String) { }
}
