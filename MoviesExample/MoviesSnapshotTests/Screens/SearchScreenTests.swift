//
//  SearchScreenTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

class SearchScreenTests: XCTestCase {
    private let dummyMultipleMovies: [ListMovieEntity] = [.dummy(repeatingString: 10)] + (1...20).map { .dummy(id: $0) }
    private let dummySingleMovie: [ListMovieEntity] = [.dummy()]

    func test_node_initial() {
        let sut = generateSUT(movies: [])

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    func test_node_trending() {
        let sut = generateSUT(movies: dummySingleMovie)
        sut.viewModel.perform(BecomeVisibleEvent())

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    func test_node_trending_multiple() {
        let sut = generateSUT(movies: dummyMultipleMovies)
        sut.viewModel.perform(BecomeVisibleEvent())

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    func test_node_search() {
        let sut = generateSUT(movies: dummySingleMovie)
        sut.viewModel.perform(SearchMovieEvent(query: "movie"))

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    func test_node_search_multiple() {
        let sut = generateSUT(movies: dummyMultipleMovies)
        sut.viewModel.perform(SearchMovieEvent(query: "movie"))

        assertNodeSnapshot(matching: sut, size: .iPhone8HalfHeight)
    }

    private func generateSUT(movies: [ListMovieEntity]) -> SearchNode {
        SearchNode(viewModel: SearchViewModel(data: .init(
            source: .init(
                getTrendingMovies: { .just(movies) },
                getSearchMovies: { _ in .just(movies) }
            ),
            navigation: .init(
                closeAllAndPopTo: { _ in },
                followMovie: { _ in nil }
            )
        )))
    }
}
