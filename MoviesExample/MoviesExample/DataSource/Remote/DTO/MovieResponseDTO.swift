//
//  MovieResponseDTO.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct MovieResponseDTO: Decodable {
    struct Genre: Decodable {
        let id: Int
        let name: String
    }

    struct ProductionCompany: Decodable {
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String
    }

    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
