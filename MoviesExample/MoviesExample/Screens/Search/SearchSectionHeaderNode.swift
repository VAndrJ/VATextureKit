//
//  SearchSectionHeaderNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class SearchSectionHeaderNode: VACellNode {
    private let titleTextNode: VATextNode

    init(viewModel: SearchSectionHeaderNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .headline,
            maximumNumberOfLines: 1
        )

        super.init()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.top(12), .horizontal(16), .bottom(8))
    }
}

class SearchSectionHeaderNodeViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title

        super.init(identity: title)
    }
}
