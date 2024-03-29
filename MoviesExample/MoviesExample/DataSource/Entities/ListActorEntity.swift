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
        self.avatar = source.profilePath
        self.character = character
    }
}

extension ListActorEntity {

    static func from(response source: CastWrapper<CastResponseDTO>) -> [ListActorEntity] {
        source.cast.compactMap(Self.init(response:))
    }
}
