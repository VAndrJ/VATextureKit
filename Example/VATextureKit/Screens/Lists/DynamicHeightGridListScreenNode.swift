//
//  DynamicHeightGridListScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct DynamicHeightGridListNavigationIdentity: DefaultNavigationIdentity {}

final class DynamicHeightGridListScreenNode: ScreenNode {
    private lazy var listNode = MainActorEscaped { [self] in
        VAListNode(
            data: .init(
                listDataObs: .just((0...100).map { _ in
                    PagerCardCellNodeViewModel(
                        title: "\((0...Int.random(in: 0...5)).map { _ in "-" }.joined(separator: "\n"))",
                        description: "–",
                        padding: .zero
                    )
                }),
                cellGetter: PagerCardCellNode.init(viewModel:)
            ),
            layoutData: .init(layout: .delegate(VADynamicHeightGridListLayoutDelegate(info: .init(
                portraitColumns: 3,
                albumColumns: 5,
                columnSpacing: 8,
                interItemSpacing: 8
            ))))
        )
    }.value

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
}
