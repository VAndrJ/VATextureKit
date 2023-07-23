//
//  CollectionListNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

// MARK: - ViewController as a View example

final class CollectionListNodeController: VANodeController {
    private(set) lazy var horizontalListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: CollectionExampleCellNode.init(viewModel:)
        ),
        layoutData: .init(
            contentInset: UIEdgeInsets(all: 8),
            sizing: .horizontal(columns: 2, ratio: 1),
            albumSizing: .horizontal(columns: 1, ratio: 1),
            layout: .default(parameters: .init(
                scrollDirection: .horizontal,
                minimumLineSpacing: 16,
                minimumInteritemSpacing: 8
            ))
        )
    ).flex(grow: 0.25)
    private(set) lazy var verticalListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: CollectionExampleCellNode.init(viewModel:)
        ),
        layoutData: .init(
            contentInset: UIEdgeInsets(all: 16),
            sizing: .vertical(columns: 2, ratio: 1),
            albumSizing: .vertical(columns: 3, ratio: 1),
            layout: .default(parameters: .init(
                minimumLineSpacing: 8,
                minimumInteritemSpacing: 8
            ))
        )
    ).flex(grow: 0.75)
    
    let viewModel: CollectionListViewModel
    
    init(viewModel: CollectionListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16, cross: .stretch) {
                horizontalListNode
                verticalListNode
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
