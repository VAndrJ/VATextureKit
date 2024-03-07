//
//  ActorCardNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class ActorCardNode: VADisplayNode {
    struct Context {
        let avatar: String?
        let name: String
        let character: String
    }

    private let avatarImageNode: VANetworkImageNode
    private let nameTextNode: VATextNode
    private let roleTextNode: VATextNode

    init(data: Context) {
        self.avatarImageNode = VANetworkImageNode(
            image: data.avatar?.getImagePath(width: 500),
            contentMode: .scaleAspectFill
        ).flex(grow: 1)
        self.nameTextNode = VATextNode(
            text: data.name,
            fontStyle: .caption1,
            alignment: .center
        )
        self.roleTextNode = VATextNode(
            text: data.character,
            fontStyle: .caption2,
            alignment: .center,
            colorGetter: { $0.secondaryLabel }
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 2, cross: .center) {
            avatarImageNode
                .ratio(113 / 83)
            nameTextNode
                .padding(.top(2))
            roleTextNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        avatarImageNode.backgroundColor = theme.systemGray5
    }
}

extension ActorCardNode.Context {

    init(listActor source: ListActorEntity) {
        self.init(
            avatar: source.avatar,
            name: source.name,
            character: source.character
        )
    }
}
