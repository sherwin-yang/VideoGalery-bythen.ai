//
//  CloudinaryURLBuilderTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/12/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class CloudinaryURLBuilderTests: XCTestCase {

    func testCreateURL() {
        let path = String.random()
        let sut = CloudinaryURLBuilder(path: path)
        XCTAssertEqual(try? sut.build().absoluteString, 
                       "https://api.cloudinary.com/v1_1/dk3lhojel/\(path)")
    }

}
