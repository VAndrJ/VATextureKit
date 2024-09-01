//
//  CollectionListDifferentCellsNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct CollectionListDifferentCellsNavigationIdentity: DefaultNavigationIdentity {}

// MARK: - ViewController as a View example

final class CollectionListDifferentCellsNodeController: VANodeController, @unchecked Sendable {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            shouldBatchFetch: viewModel.checkMoreAvailable,
            loadMore: viewModel.loadMore
        ),
        layoutData: .init(
            layout: .default(parameters: .init(
                minimumLineSpacing: 16
            ))
        ),
        refreshData: .init(
            reloadData: viewModel.reloadData,
            isLoadingObs: viewModel.isLoadingObs
        )
    )
    private let viewModel: CollectionListDifferentCellsViewModel
    
    init(viewModel: CollectionListDifferentCellsViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        contentNode.backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
}

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
