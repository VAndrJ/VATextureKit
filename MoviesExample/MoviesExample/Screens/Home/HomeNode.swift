//
//  HomeNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class HomeNode: DisplayNode<HomeViewModel> {
    private lazy var backgoundNode = VAImageNode(image: R.image.main_background())
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { HomeSectionHeaderNode(viewModel: $0.model) }
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )
    private lazy var titleTextNode = VATextNode(
        text: R.string.localizable.wip(),
        fontStyle: .largeTitle
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
        .background(backgoundNode)
        .overlay(titleTextNode.centered())
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
