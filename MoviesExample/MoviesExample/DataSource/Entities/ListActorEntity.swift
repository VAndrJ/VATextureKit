//
//  ListActorEntity.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import Foundation

struct ListActorEntity {
    let id: Id<Actor>
    let name: String
    let popularity: Double
    let avatar: String?
    let character: String
}

extension ListActorEntity {

    init?(response source: CastResponseDTO) {
        guard let character = source.character else {
            return nil
        }
        self.id = Id(rawValue: source.id)
        self.name = source.name
        self.popularity = source.popularity
        self.avatar = source.profilePath
        self.character = character
    }
}
