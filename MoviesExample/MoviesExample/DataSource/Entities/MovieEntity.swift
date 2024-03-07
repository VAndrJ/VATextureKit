//
//  MovieEntity.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct MovieEntity {
    let id: Id<Movie>
    let title: String
    let releaseDate: String
    let rating: Double
    let year: String
    let backdropPath: String?
    let genres: [GenreEntity]
    let overview: String
}

extension MovieEntity {

    init(response source: MovieResponseDTO) {
        self.init(
            id: Id(rawValue: source.id),
            title: source.title,
            releaseDate: source.releaseDate,
            rating: source.voteAverage * 10,
            year: source.releaseDate.components(separatedBy: "-").first ?? "",
            backdropPath: source.backdropPath,
            genres: source.genres.map { GenreEntity(id: .init(rawValue: $0.id), name: $0.name) },
            overview: source.overview
        )
    }
}
