//
//  MovieDetailsTitleCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class MovieDetailsTitleCellNodeTests: XCTestCase {

    func test_node_short() {
        let sut = MovieDetailsTitleCellNode(viewModel: .init(movie: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_long() {
        let sut = MovieDetailsTitleCellNode(viewModel: .init(movie: .dummy(repeatingString: 10)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
