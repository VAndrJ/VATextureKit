//
//  CollectionListDifferentCellsNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

@MainActor
private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as MainListCellNodeViewModel:
        return MainListCellNode(viewModel: viewModel)
    case let viewModel as ImageCellNodeViewModel:
        return ImageCellNode(viewModel: viewModel)
    case let viewModel as ImageNumberCellNodeViewModel:
        return ImageNumberCellNode(viewModel: viewModel)
    case let viewModel as LoadingCellNodeViewModel:
        return LoadingCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement")
        return ASCellNode()
    }
}

// MARK: - ViewController as a View example

final class CollectionListDifferentCellsNodeController: VANodeController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    private(set) lazy var leftListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            shouldBatchFetch: viewModel.checkMore,
            loadMore: viewModel.loadMore
        ),
        layoutData: .init(
            minimumLineSpacing: 16
        ),
        refreshData: .init(
            reloadData: viewModel.reloadData,
            isLoadingObs: viewModel.isLoadingObs
        )
    )
    private(set) lazy var rightListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:)
        ),
        layoutData: .init(
            minimumLineSpacing: 16,
            contentInset: UIEdgeInsets(horizontal: 16)
        )
    )
    
    let viewModel: CollectionListDifferentCellsViewModel
    
    init(viewModel: CollectionListDifferentCellsViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Row {
                leftListNode
                    .flex(grow: 1 / 3)
                rightListNode
                    .flex(grow: 2 / 3)
            }
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        contentNode.backgroundColor = theme.systemBackground
        leftListNode.backgroundColor = theme.systemBackground
        rightListNode.backgroundColor = theme.systemBackground
    }
}
