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
        let sut = ViewController(node: MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
            related: .init(listMovieEntity: .dummy()),
            source: .init(
                getMovie: { _ in .empty() },
                getRecommendations: { _ in .empty() },
                getMovieActors: { _ in .empty() }
            ),
            navigation: .init(
                followMovie: { _ in nil }
            )
        ))))

        assertControllerSnapshot(matching: sut, size: .fixed(CGSize(width: 375, height: 812)))
    }
}
