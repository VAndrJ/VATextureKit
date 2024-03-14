//
//  PagerCardCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class PagerCardCellNode: VACellNode {
    let titleTextNode: VATextNode
    let descriptionTextNode: VATextNode
    let cardNode = VADisplayNode(corner: .init(radius: .fixed(16)))

    private let viewModel: PagerCardCellNodeViewModel

    init(viewModel: PagerCardCellNodeViewModel) {
        self.viewModel = viewModel
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .largeTitle
        )
        self.descriptionTextNode = VATextNode(
            text: viewModel.description,
            fontStyle: .title1
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .center) {
            titleTextNode
            descriptionTextNode
        }
        .centered()
        .background(cardNode)
        .padding(.insets(viewModel.padding))
    }

    override func configureTheme(_ theme: VATheme) {
        cardNode.backgroundColor = theme.label.withAlphaComponent(0.12)
    }
}

class PagerCardCellNodeViewModel: CellViewModel {
    let title: String
    let description: String
    let padding: UIEdgeInsets

    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.padding = UIEdgeInsets(all: 32)
    }

    init(title: String, description: String, padding: UIEdgeInsets) {
        self.title = title
        self.description = description
        self.padding = padding
    }
}
