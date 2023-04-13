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
    let image: String?
    let overview: String
    let rating: Double
}

extension ListMovieEntity {

    init(response source: ListMovieResponseDTO) {
        self.id = Id(rawValue: source.id)
        self.title = source.title
        self.image = source.backdropPath ?? source.posterPath
        self.overview = source.overview
        self.rating = source.voteAverage * 10
    }
}
