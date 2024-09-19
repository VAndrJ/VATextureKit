//
//  MovieDetailsDescriptionCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieDetailsDescriptionCellNode: VACellNode, @unchecked Sendable {
    private let descriptionTextNode: VATextNode

    init(viewModel: MovieDetailsDescriptionCellNodeViewModel) {
        self.descriptionTextNode = VATextNode(text: viewModel.description)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        descriptionTextNode
            .padding(.horizontal(16))
    }
}

final class MovieDetailsDescriptionCellNodeViewModel: CellViewModel {
    let description: String

    init(description: String) {
        self.description = description

        super.init()
    }
}
