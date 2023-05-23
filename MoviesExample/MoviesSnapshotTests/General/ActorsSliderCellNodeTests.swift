//
//  ActorsSliderCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class ActorsSliderCellNodeTests: XCTestCase {

    func test_node_empty() {
        let sut = ActorsSliderCellNode(viewModel: .init(
            title: "Title",
            actors: [],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_single() {
        let sut = ActorsSliderCellNode(viewModel: .init(
            title: "Title",
            actors: [.dummy()],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_multiple() {
        let sut = ActorsSliderCellNode(viewModel: .init(
            title: "Title",
            actors: [.dummy(), .dummy(repeatingString: 3, id: 1), .dummy(id: 2), .dummy(id: 3)],
            onSelect: { _ in }
        ))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
