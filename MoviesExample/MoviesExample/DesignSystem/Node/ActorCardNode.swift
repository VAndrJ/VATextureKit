//
//  ActorCardNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class ActorCardNode: VADisplayNode {
    struct DTO {
        let avatar: String?
        let name: String
        let character: String
    }

    private let avatarNode: VANetworkImageNode
    private let nameTextNode: VATextNode
    private let roleTextNode: VATextNode

    init(data: DTO) {
        self.avatarNode = VANetworkImageNode(data: .init(
            image: data.avatar?.getImagePath(width: 500),
            contentMode: .scaleAspectFill
        )).flex(grow: 1)
        self.nameTextNode = VATextNode(
            text: data.name,
            textStyle: .caption1,
            alignment: .center
        )
        self.roleTextNode = VATextNode(
            text: data.character,
            textStyle: .caption2,
            alignment: .center,
            themeColor: { $0.secondaryLabel }
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 2, cross: .center) {
            avatarNode
                .ratio(113 / 83)
            nameTextNode
                .padding(.top(2))
            roleTextNode
        }
    }
}

extension ActorCardNode.DTO {

    init(listActor source: ListActorEntity) {
        self.init(
            avatar: source.avatar,
            name: source.name,
            character: source.character
        )
    }
}
