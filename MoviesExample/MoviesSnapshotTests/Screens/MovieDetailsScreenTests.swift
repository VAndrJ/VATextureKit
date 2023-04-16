//
//  MovieDetailsScreenTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class MovieDetailsScreenTests: XCTestCase {

    func test_node_initial() {
        let sut = generateSUT(isEmpty: true)

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    func test_node() {
        let sut = generateSUT(isEmpty: false)

        assertNodeSnapshot(matching: sut, size: .iPhone8)
    }

    private func generateSUT(isEmpty: Bool) -> MovieDetailsNode {
        MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
            related: .init(listMovieEntity: .dummy()),
            source: .init(
                getMovie: { _ in isEmpty ? .empty() : .just(.dummy()) },
                getRecommendations: { _ in isEmpty ? .empty() : .just([.dummy()]) },
                getMovieActors: { _ in isEmpty ? .empty() : .just([.dummy()]) }
            ),
            navigation: .init(
                followMovie: { _ in nil }
            )
        )))
    }
}
