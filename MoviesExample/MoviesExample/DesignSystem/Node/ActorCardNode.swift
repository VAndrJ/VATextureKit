//
//  ActorCardNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class ActorCardNode: VADisplayNode, @unchecked Sendable {
    struct Context {
        let avatar: String?
        let name: String
        let character: String
    }

    private let avatarImageNode: VANetworkImageNode
    private let nameTextNode: VATextNode
    private let roleTextNode: VATextNode

    init(context: Context) {
        self.avatarImageNode = VANetworkImageNode(
            image: context.avatar?.getImagePath(width: 500),
            contentMode: .scaleAspectFill
        )
        self.nameTextNode = VATextNode(
            text: context.name,
            fontStyle: .caption1,
            alignment: .center
        )
        self.roleTextNode = VATextNode(
            text: context.character,
            fontStyle: .caption2,
            alignment: .center,
            colorGetter: { $0.secondaryLabel }
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 2, cross: .center) {
            avatarImageNode
                .flex(grow: 1)
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
