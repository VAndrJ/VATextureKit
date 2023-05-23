//
//  SearchMovieCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

class SearchMovieCellNodeTests: XCTestCase {

    func test_node_short() {
        let sut = SearchMovieCellNode(viewModel: .init(listEntity: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }

    func test_node_long() {
        let sut = SearchMovieCellNode(viewModel: .init(listEntity: .dummy(repeatingString: 10)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }
}
