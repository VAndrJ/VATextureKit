//
//  TagCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class TagCellNode: VACellNode {
    let titleTextNode: VATextNode

    init(viewModel: TagCellNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .headline
        )

        super.init(corner: .init(radius: .proportional(percent: 100)))
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.vertical(2), .horizontal(8))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.label.withAlphaComponent(0.12)
    }
}

final class TagCellNodeViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
