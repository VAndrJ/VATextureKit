//
//  MovieDetailsTrailerCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class MovieDetailsTrailerCellNodeTests: XCTestCase {

    func test_node() {
        let sut = MovieDetailsTrailerCellNode(viewModel: .init(listMovie: .dummy(), dataObs: nil))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(48))
    }
}
