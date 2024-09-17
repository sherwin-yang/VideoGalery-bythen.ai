//
//  VideoGaleryViewModelTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/14/24.
//

import XCTest
import Combine

@testable import VideoGalery_bythen_ai

final class VideoGaleryViewModelTests: XCTestCase {
    
    func testInitialValues() {
        let sut = VideoGaleryViewModel.makeSUT(getUploadedVideoDetail: { [] })
        XCTAssertTrue(sut.uploadedVideoDetail.isEmpty)
        XCTAssertTrue(sut.isUploadedVideoListViewHidden)
        XCTAssertFalse(sut.isLoadingIndicatorHidden)
        XCTAssertTrue(sut.isRetryButtonHidden)
    }

    func test_viewAppear_and_retry_shouldGetUploadedVideoDetail() {
        func test(action: (VideoGaleryViewModel) -> Void, line: UInt = #line) {
            var getUploadedVideoDetailCalled = false
            let expectation = expectation(description: "getUploadedVideoDetailCalled never get called")
            expectation.expectedFulfillmentCount = 1
            let sut = VideoGaleryViewModel.makeSUT(
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
        func test(action: (VideoGaleryViewModel) -> Void, line: UInt = #line) {
            let expectation = expectation(description: "getUploadedVideoDetailCalled() never get called")
            expectation.expectedFulfillmentCount = 1
            let uploadedVideoDetails = [VideoDetail.random(), .random(), .random()]
            let sut = VideoGaleryViewModel.makeSUT(
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
        func test(action: (VideoGaleryViewModel) -> Void, line: UInt = #line) {
            let expectation = expectation(description: "getUploadedVideoDetailCalled() never get called")
            expectation.expectedFulfillmentCount = 1
            let sut = VideoGaleryViewModel.makeSUT(
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
        func test(action: (VideoGaleryViewModel) -> Void, line: UInt = #line) {
            let sut = VideoGaleryViewModel.makeSUT(
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

private extension VideoGaleryViewModel {
    static func makeSUT(
        getUploadedVideoDetail: @escaping () async throws -> [VideoDetail] = { [] },
        deleteItem: @escaping (String) -> Void = { _ in },
        observeVideoUploading: @escaping () -> AnyPublisher<UploadVideoStatus, Never>
        = { Just(UploadVideoStatus.none).eraseToAnyPublisher() },
        retryVideoUpload: @escaping () -> Void = { },
        cancelLastUploadVideo: @escaping () -> Void = { }
    ) -> VideoGaleryViewModel {
        .init(getUploadedVideoDetail: getUploadedVideoDetail,
              deleteItem: deleteItem,
              observeVideoUploading: observeVideoUploading, 
              retryVideoUpload: retryVideoUpload,
              cancelLastUploadVideo: cancelLastUploadVideo)
    }
}

extension VideoDetail {
    static func random() -> Self {
        .init(publicId: .random(), secureUrl: URL(string: .random())!, createdAt: .random())
    }
}
