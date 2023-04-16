//
//  SearchScreenTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

// MARK: - Run on iPhone X/XS
@MainActor
class SearchScreenTests: XCTestCase {

    func test_node_initial() {
        let sut = ViewController(node: SearchNode(viewModel: SearchViewModel(data: .init(
            source: .init(
                getTrendingMovies: { .empty() },
                getSearchMovies: { _ in .empty() }),
            navigation: .init(followMovie: { _ in nil })
        ))))

        assertControllerSnapshot(matching: sut, size: .fixed(CGSize(width: 375, height: 812)))
    }
}
