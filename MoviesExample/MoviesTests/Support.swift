//
//  Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
import RxSwift
@testable import MoviesExample

class Support {
}

extension String {
    static var coverFilePath = Bundle(for: Support.self).path(forResource: "test_cover", ofType: "jpg")!
    static var posterFilePath = Bundle(for: Support.self).path(forResource: "test_poster", ofType: "jpg")!

    func dummyLong(separator: String = " ", range: ClosedRange<Int> = 0...10) -> String {
        range.map { _ in self }.joined(separator: separator)
    }
}

extension ListMovieEntity {

    static func dummy(repeatingString: Int = 0, id: Int = 0) -> Self {
        .init(
            id: .init(rawValue: id),
            title: "Movie".dummyLong(range: 0...repeatingString),
            backdropPath: .coverFilePath,
            posterPath: .posterFilePath,
            overview: "Overview".dummyLong(range: 0...repeatingString),
            rating: 80,
            year: "2020"
        )
    }
}

extension ListActorEntity {

    static func dummy(repeatingString: Int = 0, id: Int = 0) -> Self {
        .init(
            id: .init(rawValue: id),
            name: "Name".dummyLong(range: 0...repeatingString),
            avatar: .posterFilePath,
            character: "Character".dummyLong(range: 0...repeatingString)
        )
    }
}

extension GenreEntity {

    static func dummy(repeatingString: Int = 0, id: Int = 0) -> Self {
        .init(
            id: .init(rawValue: id),
            name: "Genre".dummyLong(range: 0...repeatingString)
        )
    }
}

extension MovieEntity {

    static func dummy(repeatingString: Int = 0, id: Int = 0) -> Self {
        .init(
            id: .init(rawValue: id),
            title: "Title".dummyLong(range: 0...repeatingString),
            releaseDate: "2023-11-11",
            rating: 80,
            year: "2023",
            backdropPath: .coverFilePath,
            genres: (0...repeatingString).map { .dummy(id: $0) },
            overview: "Overview".dummyLong(range: 0...repeatingString)
        )
    }
}

extension XCTestCase {

    func spy<T>(_ observable: Observable<T>, initialExpectation: XCTestExpectation? = nil, timeout: TimeInterval = 10) -> ObservableSpy<T> {
        ObservableSpy(
            observable,
            initialExpectation: initialExpectation,
            expectationGetter: { self.expectation(description: "Observable spy") },
            waiter: { self.wait(for: [$0], timeout: timeout) }
        )
    }
}

final class ObservableSpy<T> {
    private(set) var result: [T] = []
    private(set) var errors: [Error] = []

    private var disposable: Disposable?
    private var expectationGetter: () -> XCTestExpectation
    private var waiter: (XCTestExpectation) -> Void
    private var expectation: XCTestExpectation?

    init(
        _ observable: Observable<T>,
        initialExpectation: XCTestExpectation? = nil,
        expectationGetter: @escaping () -> XCTestExpectation,
        waiter: @escaping (XCTestExpectation) -> Void
    ) {
        self.expectationGetter = expectationGetter
        self.waiter = waiter
        self.expectation = initialExpectation

        disposable = observable
            .subscribe(
                onNext: { [weak self] in
                    self?.result.append($0)
                    self?.expectation?.fulfill()
                    self?.expectation = nil
                },
                onError: { [weak self] in
                    self?.errors.append($0)
                    self?.expectation?.fulfill()
                    self?.expectation = nil
                }
            )
    }

    func wait(_ expression: @escaping () -> Void) {
        let expectation = expectationGetter()
        self.expectation = expectation
        expression()
        waiter(expectation)
    }
}
