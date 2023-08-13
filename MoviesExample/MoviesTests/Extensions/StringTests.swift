//
//  StringTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

final class StringTests: XCTestCase {

    func test_ns() {
        let string = "123asdf"
        let expected = string as NSString

        XCTAssertEqual(expected, string.ns)
    }

    func test_image_path() {
        let expected = "https://image.tmdb.org/t/p/w500/path"

        XCTAssertEqual(expected, "/path".getImagePath(width: 500))
        XCTAssertEqual(expected, expected.getImagePath(width: 500))
    }
}
