//
//  HomeScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class HomeScreenNode: ScreenNode<HomeViewModel> {
    private let backgoundNode = VAImageNode(image: R.image.main_background())
    private lazy var listNode = VAListNode(
        context: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { HomeSectionHeaderNode(viewModel: $0.model) }
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )
    private let titleTextNode = VATextNode(
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
