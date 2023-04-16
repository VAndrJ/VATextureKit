//
//  CollectionTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

final class CollectionTests: XCTestCase {

    func test_is_not_empty() {
        let emptyArr: [Int] = []
        let notEmptyArr = [1]

        XCTAssertFalse(emptyArr.isNotEmpty)
        XCTAssertTrue(notEmptyArr.isNotEmpty)
    }
}
