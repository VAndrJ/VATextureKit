//
//  ListMovieEntity.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

struct ListMovieEntity: Equatable {
    let id: Id<Movie>
    let title: String
    var backdropPath: String?
    var posterPath: String?
    let overview: String
    let rating: Double
    let year: String
    var image: String? { backdropPath ?? posterPath }
    var poster: String? { posterPath ?? backdropPath }
}

extension ListMovieEntity {

    init(response source: ListMovieResponseDTO) {
        self.id = Id(rawValue: source.id)
        self.title = source.title
        self.backdropPath = source.backdropPath
        self.posterPath = source.posterPath
        self.overview = source.overview
        self.rating = source.voteAverage * 10
        self.year = source.releaseDate.components(separatedBy: "-").first ?? ""
    }
}

extension ListMovieEntity {

    static func from(response source: ResultsWrapper<ListMovieResponseDTO>) -> [ListMovieEntity] {
        source.results.map(Self.init(response:))
    }
}
