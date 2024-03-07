//
//  ListMovieEntity.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

struct ListMovieEntity: Equatable, Sendable {
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

    init?(queryItems source: [URLQueryItem]?) {
        guard let queryItems = source,
            let item = queryItems.first(where: { $0.name == "id" }),
            let id = item.value.flatMap({ Int($0).flatMap { Id<Movie>(rawValue: $0) } }),
            let title = queryItems.first(where: { $0.name == "title" })?.value,
            let year = queryItems.first(where: { $0.name == "year" })?.value else {
            return nil
        }

        self.init(
            id: id,
            title: title,
            overview: "",
            rating: 0,
            year: year
        )
    }

    init(response source: ListMovieResponseDTO) {
        self.init(
            id: Id(rawValue: source.id),
            title: source.title,
            backdropPath: source.backdropPath,
            posterPath: source.posterPath,
            overview: source.overview,
            rating: source.voteAverage * 10,
            year: source.releaseDate.components(separatedBy: "-").first ?? ""
        )
    }
}

extension ListMovieEntity {

    static func from(response source: ResultsWrapper<ListMovieResponseDTO>) -> [ListMovieEntity] {
        source.results.map(Self.init(response:))
    }
}
