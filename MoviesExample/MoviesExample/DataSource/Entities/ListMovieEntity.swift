//
//  ListMovieEntity.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

struct ListMovieEntity {
    let id: Id<Movie>
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let rating: Double
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
    }
}
