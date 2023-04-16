//
//  SearchScreenTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

// MARK: - Run on iPhone X/XS
// MARK: - There is an issue with the section header/footer on snapshots
@MainActor
class SearchScreenTests: XCTestCase {

    func test_node_initial() {
        let sut = SearchNode(viewModel: SearchViewModel(data: .init(
            source: .init(
                getTrendingMovies: { .empty() },
                getSearchMovies: { _ in .empty() }
            ),
            navigation: .init(followMovie: { _ in nil })
        )))

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }

    func test_node_trending() {
        let sut = SearchNode(viewModel: SearchViewModel(data: .init(
            source: .init(
                getTrendingMovies: { .just([.dummy()]) },
                getSearchMovies: { _ in .empty() }
            ),
            navigation: .init(followMovie: { _ in nil })
        )))
        sut.viewModel.perform(BecomeVisibleEvent())

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }

    func test_node_trending_multiple() {
        let sut = SearchNode(viewModel: SearchViewModel(data: .init(
            source: .init(
                getTrendingMovies: {
                    .just([
                        .dummy(),
                        .dummy(repeatingString: 10, id: 1),
                        .dummy(repeatingString: 1, id: 2),
                        .dummy(repeatingString: 3, id: 3),
                        .dummy(repeatingString: 4, id: 4),
                        .dummy(repeatingString: 5, id: 5),
                        .dummy(id: 6),
                    ])
                },
                getSearchMovies: { _ in .empty() }
            ),
            navigation: .init(followMovie: { _ in nil })
        )))
        sut.viewModel.perform(BecomeVisibleEvent())

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }
}
