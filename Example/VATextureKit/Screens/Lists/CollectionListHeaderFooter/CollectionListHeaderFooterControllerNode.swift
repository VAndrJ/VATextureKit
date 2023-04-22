//
//  CollectionListHeaderFooterControllerNode.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 22.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
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
    private(set) lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            cellGetter: mapToCell(viewModel:),
            headerGetter: { sectionModel in
                sectionModel.model.headerViewModel.flatMap(mapToCell(viewModel:))
            },
            footerGetter: { sectionModel in
                sectionModel.model.footerViewModel.flatMap(mapToCell(viewModel:))
            }
        ),
        layoutData: .init(
            sectionHeadersPinToVisibleBounds: true,
            sectionFootersPinToVisibleBounds: true,
            minimumLineSpacing: 16
        )
    )

    let viewModel: CollectionListHeaderFooterViewModel

    init(viewModel: CollectionListHeaderFooterViewModel) {
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

        backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
}
