//
//  MovieCardNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class MovieCardNodeTests: XCTestCase {

    func test_node_short() {
        let sut = MovieCardNode(data: .init(listMovie: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(85))
    }

    func test_node_long() {
        let sut = MovieCardNode(data: .init(listMovie: .dummy(repeatingString: 3)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(85))
    }
}
