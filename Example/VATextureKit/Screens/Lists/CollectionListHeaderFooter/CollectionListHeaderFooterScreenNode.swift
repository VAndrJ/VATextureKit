//
//  CollectionListHeaderFooterScreenNode.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct CollectionListHeaderFooterNavigationIdentity: DefaultNavigationIdentity {}

extension CollectionListHeaderFooterScreenNode {

    convenience init() {
        self.init(viewModel: .init())
    }
}

final class CollectionListHeaderFooterScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var leftListNode = VAListNode(
        context: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { $0.model.headerViewModel.flatMap(mapToCell(viewModel:)) },
            footerGetter: { $0.model.footerViewModel.flatMap(mapToCell(viewModel:)) },
            moveItem: viewModel.moveItem(source:destination:)
        ),
        layoutData: .init(
            layout: .default(parameters: .init(
                minimumLineSpacing: 8,
                sectionHeadersPinToVisibleBounds: true,
                sectionFootersPinToVisibleBounds: true
            ))
        )
    ).flex(basisPercent: 50)
    private lazy var rightListNode = VAListNode(
        context: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { $0.model.headerViewModel.flatMap(mapToCell(viewModel:)) },
            footerGetter: { $0.model.footerViewModel.flatMap(mapToCell(viewModel:)) },
            moveItem: viewModel.moveItem(source:destination:)
        ),
        layoutData: .init(
            sizing: .vertical(columns: 2, ratio: 1),
            layout: .default(parameters: .init(
                minimumLineSpacing: 8,
                minimumInteritemSpacing: 8,
                sectionHeadersPinToVisibleBounds: true,
                sectionFootersPinToVisibleBounds: true
            ))
        )
    ).flex(basisPercent: 50)

    let viewModel: CollectionListHeaderFooterViewModel

    init(viewModel: CollectionListHeaderFooterViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Row {
                leftListNode
                rightListNode
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
