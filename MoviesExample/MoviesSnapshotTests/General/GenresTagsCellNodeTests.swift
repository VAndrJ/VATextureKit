//
//  GenresTagsCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class GenresTagsCellNodeTests: XCTestCase {

    func test_node_empty() {
        let sut = GenresTagsCellNode(viewModel: .init(genres: []))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_single() {
        let sut = GenresTagsCellNode(viewModel: .init(genres: [.dummy()]))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_multiple() {
        let sut = GenresTagsCellNode(viewModel: .init(genres: [
            .dummy(),
            .dummy(repeatingString: 1, id: 1),
            .dummy(id: 2),
            .dummy(repeatingString: 5, id: 3),
            .dummy(id: 4),
        ]))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
