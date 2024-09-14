//
//  UploadedVideoListViewModelTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class UploadedVideoListViewModelTests: XCTestCase {
    
    func testInitialValues() {
        let sut = UploadedVideoListViewModel(getUploadedVideoDetail: { [] })
        XCTAssertTrue(sut.uploadedVideoDetail.isEmpty)
        XCTAssertTrue(sut.isUploadedVideoListViewHidden)
        XCTAssertFalse(sut.isLoadingIndicatorHidden)
        XCTAssertTrue(sut.isRetryButtonHidden)
    }

    func test_viewAppear_and_retry_shouldGetUploadedVideoDetail() {
        func test(action: (UploadedVideoListViewModel) -> Void, line: UInt = #line) {
            var getUploadedVideoDetailCalled = false
            let expectation = expectation(description: "getUploadedVideoDetailCalled never get called")
            expectation.expectedFulfillmentCount = 1
            let sut = UploadedVideoListViewModel(
                getUploadedVideoDetail: {
                    getUploadedVideoDetailCalled = true
                    expectation.fulfill()
                    return []
                }
            )
            
            action(sut)
            waitForExpectations(timeout: 1)
            
            XCTAssertTrue(getUploadedVideoDetailCalled, line: line)
        }
        
        test(action: { $0.viewAppear() })
        test(action: { $0.retry() })
    }
    
    @MainActor
    func testGetUploadedVideoDetailSuccess() {
        func test(action: (UploadedVideoListViewModel) -> Void, line: UInt = #line) {
            let expectation = expectation(description: "getUploadedVideoDetailCalled() never get called")
            expectation.expectedFulfillmentCount = 1
            let uploadedVideoDetails = [UploadedVideoDetail.random(), .random(), .random()]
            let sut = UploadedVideoListViewModel(
                getUploadedVideoDetail: {
                    expectation.fulfill()
                    return uploadedVideoDetails
                }
            )
            
            action(sut)
            waitForExpectations(timeout: 1)
            
            XCTAssertEqual(sut.uploadedVideoDetail, uploadedVideoDetails)
            XCTAssertFalse(sut.isUploadedVideoListViewHidden)
            XCTAssertTrue(sut.isLoadingIndicatorHidden)
            XCTAssertTrue(sut.isRetryButtonHidden)
        }
        
        test(action: { $0.viewAppear() })
        test(action: { $0.retry() })
    }
    
    @MainActor
    func testGetUploadedVideoDetailError() {
        func test(action: (UploadedVideoListViewModel) -> Void, line: UInt = #line) {
            let expectation = expectation(description: "getUploadedVideoDetailCalled() never get called")
            expectation.expectedFulfillmentCount = 1
            let sut = UploadedVideoListViewModel(
                getUploadedVideoDetail: {
                    expectation.fulfill()
                    throw ErrorInTest.sample
                }
            )
            let initialUploadedVideoDetail = sut.uploadedVideoDetail
            
            action(sut)
            waitForExpectations(timeout: 1)
            
            XCTAssertEqual(sut.uploadedVideoDetail, initialUploadedVideoDetail)
            XCTAssertTrue(sut.isUploadedVideoListViewHidden)
            XCTAssertTrue(sut.isLoadingIndicatorHidden)
            XCTAssertFalse(sut.isRetryButtonHidden)
        }
        
        test(action: { $0.viewAppear() })
        test(action: { $0.retry() })
    }
    
    func testRetry_shouldShowLoadingIndicator_andHideRetryButton() {
        func test(action: (UploadedVideoListViewModel) -> Void, line: UInt = #line) {
            let sut = UploadedVideoListViewModel(
                getUploadedVideoDetail: {
                    try await Task.sleep(nanoseconds: 1_000_000)
                    return []
                }
            )
            
            action(sut)
            
            XCTAssertFalse(sut.isLoadingIndicatorHidden)
            XCTAssertTrue(sut.isRetryButtonHidden)
        }
        
        test(action: { $0.viewAppear() })
        test(action: { $0.retry() })
    }

}

extension UploadedVideoDetail {
    static func random() -> Self {
        .init(publicId: .random(), secureUrl: URL(string: .random())!, createdAt: .random())
    }
}
