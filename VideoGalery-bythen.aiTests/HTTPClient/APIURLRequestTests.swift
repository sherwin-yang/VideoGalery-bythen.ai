//
//  ApiURLRequestTests.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/12/24.
//

import XCTest

@testable import VideoGalery_bythen_ai

final class APIURLRequestTests: XCTestCase {
    
    private var sut: URLRequestBuilder!
    
    override func setUpWithError() throws {
        sut = APIURLRequest(url: URL(string: "any_url_\(String.random())")!)
    }

    func testSetMethod() {
        XCTAssertEqual(sut.setMethod(.GET).build().httpMethod, "GET")
        XCTAssertEqual(sut.setMethod(.POST).build().httpMethod, "POST")
        XCTAssertEqual(sut.setMethod(.DELETE).build().httpMethod, "DELETE")
    }
    
    func testSetHeaderOnly() {
        XCTAssertNil(sut.build().allHTTPHeaderFields)
        
        let header = [
            String(Int.random(in: 0..<10)): String.random(),
            String(Int.random(in: 10..<20)): String.random(),
            String(Int.random(in: 20..<30)): String.random()
        ]
        XCTAssertEqual(sut.setHeader(header).build().allHTTPHeaderFields, header)
    }
    
    func testSetBodyOnly() throws {
        XCTAssertNil(sut.build().httpBody)
        
        let body: [String : Any] = [
            String(Int.random(in: 0..<10)): Int.random(),
            String(Int.random(in: 10..<20)): String.random(),
            String(Int.random(in: 20..<30)): Bool.random()
        ]
        
        let httpBody = try XCTUnwrap(sut.setBody(body).build().httpBody)
        let urlRequestBodyJson = String(data: httpBody, encoding: .utf8)!
        
        XCTAssertEqual(urlRequestBodyJson.first, "{")
        body.forEach {
            $0.1 is String
            ? XCTAssertTrue(urlRequestBodyJson.contains("\"\($0.0)\":\"\($0.1)\""))
            : XCTAssertTrue(urlRequestBodyJson.contains("\"\($0.0)\":\($0.1)"))
        }
        XCTAssertEqual(urlRequestBodyJson.last, "}")
    }
}
