//
//  SearchSectionHeaderNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class SearchSectionHeaderNodeTests: XCTestCase {

    func test_node_short() {
        let sut = SearchSectionHeaderNode(viewModel: .init(title: "Title"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }

    func test_node_long() {
        let sut = SearchSectionHeaderNode(viewModel: .init(title: "Title".dummyLong()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(390))
    }
}
