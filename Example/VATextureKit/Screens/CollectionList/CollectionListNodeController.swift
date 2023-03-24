//
//  CollectionListNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class CollectionListNodeController: VANodeController {
    private(set) lazy var horizontalListNode = VACollectionListNode(
        data: .init(
            listData: viewModel.listDataObs,
            onSelect: { _ in },
            cellGetter: CollectionExampleCellNode.init(viewModel:)
        ),
        layout: .init(
            scrollDirection: .horizontal,
            minimumLineSpacing: 16,
            minimumInteritemSpacing: 8,
            contentInset: UIEdgeInsets(all: 8),
            sizing: .horizontal(columns: 2, ratio: 1),
            albumSizing: .horizontal(columns: 1, ratio: 1)
        )
    )
    private(set) lazy var verticalListNode = VACollectionListNode(
        data: .init(
            listData: viewModel.listDataObs,
            onSelect: { _ in },
            cellGetter: CollectionExampleCellNode.init(viewModel:)
        ),
        layout: .init(
            minimumLineSpacing: 8,
            minimumInteritemSpacing: 8,
            contentInset: UIEdgeInsets(all: 16),
            sizing: .vertical(columns: 2, ratio: 1),
            albumSizing: .vertical(columns: 3, ratio: 1)
        )
    )
    
    let viewModel: CollectionListViewModel
    
    init(viewModel: CollectionListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16, cross: .stretch) {
                horizontalListNode
                    .flex(grow: 0.25)
                verticalListNode
                    .flex(grow: 0.75)
            }
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        contentNode.backgroundColor = theme.systemBackground
        horizontalListNode.backgroundColor = theme.systemBackground
        verticalListNode.backgroundColor = theme.systemBackground
    }
}
