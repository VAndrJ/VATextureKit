//
//  GenreTagNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class GenreTagNodeTests: XCTestCase {

    func test_node_short() {
        let sut = GenreTagNode(genre: "Title")

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_long() {
        let sut = GenreTagNode(genre: "Title".dummyLong())

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
