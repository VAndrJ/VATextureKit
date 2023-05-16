//
//  MainSectionHeaderNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 05.05.2023.
//

import VATextureKit

final class MainSectionHeaderNode: VACellNode {
    private let titleTextNode: VATextNode

    init(viewModel: MainSectionHeaderNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .init(pointSize: 22, weight: .semibold),
            maximumNumberOfLines: 1
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.vertical(8), .horizontal(16))
    }
}

class MainSectionHeaderNodeViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title

        super.init(identity: title)
    }
}
