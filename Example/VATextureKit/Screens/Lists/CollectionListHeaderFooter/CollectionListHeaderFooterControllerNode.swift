//
//  CollectionListHeaderFooterControllerNode.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

@MainActor
private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as ImageNumberCellNodeViewModel:
        return ImageNumberCellNode(viewModel: viewModel)
    case let viewModel as CollectionListSectionFooterViewModel:
        return CollectionListSectionFooterCellNode(viewModel: viewModel)
    case let viewModel as CollectionListSectionHeaderViewModel:
        return CollectionListSectionHeaderCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement \(type(of: viewModel))")
        return ASCellNode()
    }
}

final class CollectionListHeaderFooterControllerNode: VASafeAreaDisplayNode {
    private(set) lazy var leftListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { $0.model.headerViewModel.flatMap(mapToCell(viewModel:)) },
            footerGetter: { $0.model.footerViewModel.flatMap(mapToCell(viewModel:)) },
            moveItem: viewModel.moveItem(source:destination:)
        ),
        layoutData: .init(
            sectionHeadersPinToVisibleBounds: true,
            sectionFootersPinToVisibleBounds: true,
            minimumLineSpacing: 8
        )
    )
    private(set) lazy var rightListNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { $0.model.headerViewModel.flatMap(mapToCell(viewModel:)) },
            footerGetter: { $0.model.footerViewModel.flatMap(mapToCell(viewModel:)) },
            moveItem: viewModel.moveItem(source:destination:)
        ),
        layoutData: .init(
            sectionHeadersPinToVisibleBounds: true,
            sectionFootersPinToVisibleBounds: true,
            minimumLineSpacing: 8,
            minimumInteritemSpacing: 8,
            sizing: .vertical(columns: 2, ratio: 1)
        )
    )

    let viewModel: CollectionListHeaderFooterViewModel

    init(viewModel: CollectionListHeaderFooterViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Row {
                leftListNode
                    .flex(basisPercent: 50)
                rightListNode
                    .flex(basisPercent: 50)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
        leftListNode.backgroundColor = theme.systemBackground
        rightListNode.backgroundColor = theme.systemBackground
    }
}
