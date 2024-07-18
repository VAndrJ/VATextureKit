//
//  ActorDetailsScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import VATextureKit

final class ActorDetailsScreenNode: ScreenNode<ActorDetailsViewModel> {
    let titleTextNode = VATextNode(
        text: L.wip(),
        fontStyle: .largeTitle
    )

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .centered()
    }
}

final class ActorDetailsViewModel: EventViewModel, @unchecked Sendable {
    let actor: ListActorEntity

    init(actor: ListActorEntity) {
        self.actor = actor
    }
}
