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
    let cardNode = ASDisplayNode().apply {
        $0.cornerRadius = 16
    }

    init(viewModel: PagerCardCellNodeViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title, fontStyle: .largeTitle)
        self.descriptionTextNode = VATextNode(text: viewModel.description, fontStyle: .title1)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .center) {
            titleTextNode
            descriptionTextNode
        }
        .centered()
        .background(cardNode)
        .padding(.all(32))
    }

    override func configureTheme(_ theme: VATheme) {
        cardNode.backgroundColor = theme.label.withAlphaComponent(0.12)
    }
}

class PagerCardCellNodeViewModel: CellViewModel {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
