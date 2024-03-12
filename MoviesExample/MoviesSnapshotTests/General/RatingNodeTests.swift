//
//  RatingNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class RatingNodeTests: XCTestCase {

    func test_node() {
        [0.0, 20, 40, 60, 80, 100].forEach { rating in
            let sut = RatingNode(rating: rating)

            assertNodeSnapshot(matching: sut, size: .auto, additions: String(format: "rating-%.f", rating))
        }
    }
}
