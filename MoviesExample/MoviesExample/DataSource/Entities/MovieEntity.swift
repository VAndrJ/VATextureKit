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
        self.id = Id(rawValue: source.id)
        self.title = source.title
        self.releaseDate = source.releaseDate
        self.rating = source.voteAverage * 10
        self.year = source.releaseDate.split(separator: "-").first.flatMap(String.init) ?? ""
        self.backdropPath = source.backdropPath
        self.genres = source.genres.map { GenreEntity(id: .init(rawValue: $0.id), name: $0.name) }
        self.overview = source.overview
    }
}
