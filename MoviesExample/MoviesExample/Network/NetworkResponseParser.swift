//
//  NetworkResponseParser.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct NetworkResponseParser {
    let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy

    init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
    }

    func parse<T: Decodable>(data: Data?, type: T.Type = T.self) throws -> T {
        guard let data else {
            throw NetworkError.emptyResponseData
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        return try decoder.decode(type, from: data)
    }
}
