//
//  CastResponseDTO.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import Foundation

struct CastResponseDTO: Decodable {
    let id: Int
    let name: String
    let popularity: Double
    let profilePath: String?
    let character: String?
}
