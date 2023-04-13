//
//  ListMovieResponseDTO.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct ListMovieResponseDTO: Decodable {
    let id: Int
    let backdropPath: String?
    let voteAverage: Double
    let posterPath: String?
    let title: String
    let overview: String
}
