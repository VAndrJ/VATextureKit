//
//  CollectionListSectionFooterCellNode.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class CollectionListSectionFooterCellNode: VACellNode {
    private let titleTextNode: VATextNode

    init(viewModel: CollectionListSectionFooterViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemGreen
    }
}

class CollectionListSectionFooterViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
