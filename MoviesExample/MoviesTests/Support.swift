//
//  Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 15.04.2023.
//

import Foundation
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
    static func dummy(repeatingString: Int = 0) -> Self {
        .init(
            id: 1,
            title: "Movie".dummyLong(range: 0...repeatingString),
            backdropPath: .coverFilePath,
            posterPath: .posterFilePath,
            overview: "Overview".dummyLong(range: 0...repeatingString),
            rating: 80
        )
    }
}
