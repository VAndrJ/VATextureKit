//
//  CollectionListSectionHeaderCellNode.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 22.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import VATextureKit

class CollectionListSectionHeaderCellNode: VACellNode {
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

class CollectionListSectionHeaderViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
