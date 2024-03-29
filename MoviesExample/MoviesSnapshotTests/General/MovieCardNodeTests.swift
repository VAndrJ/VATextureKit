//
//  MovieCardNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class MovieCardNodeTests: XCTestCase {

    func test_node_short() {
        let sut = MovieCardNode(viewModel: .init(listMovie: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(85))
    }

    func test_node_long() {
        let sut = MovieCardNode(viewModel: .init(listMovie: .dummy(repeatingString: 3)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(85))
    }
}
