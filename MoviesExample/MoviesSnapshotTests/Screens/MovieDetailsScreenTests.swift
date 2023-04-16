//
//  MovieDetailsScreenTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

// MARK: - Run on iPhone X/XS
@MainActor
class MovieDetailsScreenTests: XCTestCase {

    func test_node_initial() {
        let sut = MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
            related: .init(listMovieEntity: .dummy()),
            source: .init(
                getMovie: { _ in .empty() },
                getRecommendations: { _ in .empty() },
                getMovieActors: { _ in .empty() }
            ),
            navigation: .init(
                followMovie: { _ in nil }
            )
        )))

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }

    func test_node() {
        let sut = MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
            related: .init(listMovieEntity: .dummy()),
            source: .init(
                getMovie: { _ in .just(.dummy()) },
                getRecommendations: { _ in .just([.dummy()]) },
                getMovieActors: { _ in .just([.dummy()]) }
            ),
            navigation: .init(
                followMovie: { _ in nil }
            )
        )))

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }
}
