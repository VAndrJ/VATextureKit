//
//  MainNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import Swiftional

final class MainNode: DisplayNode<MainViewModel> {
    private lazy var backgoundNode = VAImageNode(data: .init(image: R.image.main_background()))
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { MainSectionHeaderNode(viewModel: $0.model) }
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
        .background(backgoundNode)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
