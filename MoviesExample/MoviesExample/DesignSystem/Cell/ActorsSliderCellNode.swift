//
//  ActorsSliderCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class ActorsSliderCellNode: VACellNode {
    private let titleTextNode: VATextNode
    private lazy var listNode = VAScrollNode(context: .init(
        scrollableDirections: .horizontal,
        alwaysBounceVertical: false,
        contentInset: .init(horizontal: 16)
    ))
    private let acrorNodes: [ASDisplayNode]
    private let viewModel: MovieActorsCellNodeViewModel

    init(viewModel: MovieActorsCellNodeViewModel) {
        self.viewModel = viewModel
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .headline
        )
        self.acrorNodes = viewModel.actors.map { listActor in
            VAContainerButtonNode(
                child: ActorCardNode(context: .init(listActor: listActor)),
                onTap: viewModel.onSelect <<| listActor
            )
        }

        super.init()

        listNode.layoutSpecBlock = { [weak self] _, size in
            self?.layoutSpecScroll(constrainedSize: size) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            listNode
        }
        .padding(.vertical(24))
    }

    func layoutSpecScroll(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 8) {
            acrorNodes
                .sized(width: constrainedSize.min.width / 4)
        }
    }
}

final class MovieActorsCellNodeViewModel: CellViewModel {
    let title: String
    let actors: [ListActorEntity]
    let onSelect: (ListActorEntity) -> Void

    init(
        title: String,
        actors: [ListActorEntity],
        onSelect: @escaping (ListActorEntity) -> Void
    ) {
        self.title = title
        self.actors = actors
        self.onSelect = onSelect

        super.init()
    }
}
