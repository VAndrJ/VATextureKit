//
//  SearchTrendingMovieCellNodeTests.swift
//  MoviesExample
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class SearchTrendingMovieCellNodeTests: XCTestCase {

    func test_node_short() {
        let sut = SearchTrendingMovieCellNode(viewModel: .init(listEntity: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }

    func test_node_long() {
        let sut = SearchTrendingMovieCellNode(viewModel: .init(listEntity: .dummy(repeatingString: 10)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }
}
