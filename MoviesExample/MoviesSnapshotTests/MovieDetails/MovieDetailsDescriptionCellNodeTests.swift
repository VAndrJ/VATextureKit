//
//  MovieDetailsDescriptionCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class MovieDetailsDescriptionCellNodeTests: XCTestCase {

    func test_node_short() {
        let sut = MovieDetailsDescriptionCellNode(viewModel: .init(description: "Text"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_long() {
        let sut = MovieDetailsDescriptionCellNode(viewModel: .init(description: "Text".dummyLong(range: 0...20)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
