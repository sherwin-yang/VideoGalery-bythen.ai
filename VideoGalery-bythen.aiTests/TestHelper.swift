//
//  TestHelper.swift
//  VideoGalery-bythen.aiTests
//
//  Created by Sherwin Yang on 9/12/24.
//

import XCTest

enum NoErrorExpectation: Error { case none }

func XCTAssertThrowsError<T, R>(
    _ expression: @autoclosure () async throws -> T,
    expectedError: R = NoErrorExpectation.none,
    useThisOrAddAssertion: (Error) -> () = { _ in },
    failMessage: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async where R: Equatable, R: Error {
    do {
        _ = try await expression()
        XCTFail(failMessage, file: file, line: line)
    } catch {
        if expectedError as? NoErrorExpectation == nil {
            XCTAssertEqual(error as? R, expectedError, file: file, line: line)
        }
        useThisOrAddAssertion(error)
    }
}

extension String {
    static func random() -> Self {
        String((0...3).compactMap { _ in "abcdefghijklmnopqrstuvwxyz".randomElement() })
    }
}

extension Int {
    static func random() -> Self {
        .random(in: 0...100)
    }
}
