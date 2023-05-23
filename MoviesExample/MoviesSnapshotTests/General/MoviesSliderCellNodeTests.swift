//
//  MoviesSliderCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class MoviesSliderCellNodeTests: XCTestCase {

    func test_node_empty() {
        let sut = MoviesSliderCellNode(viewModel: .init(
            title: "Title",
            movies: [],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_single() {
        let sut = MoviesSliderCellNode(viewModel: .init(
            title: "Title",
            movies: [.dummy()],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_multiple() {
        let sut = MoviesSliderCellNode(viewModel: .init(
            title: "Title",
            movies: [.dummy(), .dummy(repeatingString: 3, id: 1), .dummy(id: 2), .dummy(id: 3)],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
