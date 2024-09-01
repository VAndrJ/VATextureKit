//
//  CollectionListSectionHeaderCellNode.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class CollectionListSectionHeaderCellNode: VACellNode, @unchecked Sendable {
    private let titleTextNode: VATextNode

    init(viewModel: CollectionListSectionHeaderViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemOrange
    }
}

final class CollectionListSectionHeaderViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
