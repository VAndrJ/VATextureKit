//
//  MovieDetailsNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
import Swiftional

@MainActor
final class MovieDetailsNode: DisplayNode<MovieDetailsViewModel> {
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            onSelect: { [viewModel] in viewModel.perform(DidSelectEvent(indexPath: $0)) },
            cellGetter: mapToCell(viewModel:)
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
