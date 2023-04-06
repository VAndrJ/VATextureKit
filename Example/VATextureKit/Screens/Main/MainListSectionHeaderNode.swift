//
//  MainListSectionHeaderNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class MainListSectionHeaderNode: VADisplayNode {
    private let titleTextNode: VATextNode

    init(viewModel: MainSectionHeaderNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            textStyle: .headline,
            lineBreakMode: .byTruncatingTail,
            maximumNumberOfLines: 1
        )

        super.init()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.tertiarySystemGroupedBackground
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.top(12), .horizontal(12), .bottom(8))
    }
}

class MainSectionHeaderNodeViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
