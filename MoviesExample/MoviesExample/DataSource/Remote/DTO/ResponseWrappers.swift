//
//  ResponseWrappers.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct ResultsWrapper<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}

struct CastWrapper<T: Decodable>: Decodable {
    let cast: [T]
}
