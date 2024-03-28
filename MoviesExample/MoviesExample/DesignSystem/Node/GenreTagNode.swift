//
//  GenreTagNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class GenreTagNode: VADisplayNode {
    private let titleTextNode: VATextNode

    init(genre: String) {
        self.titleTextNode = VATextNode(
            text: genre,
            fontStyle: .subhead,
            maximumNumberOfLines: 1,
            colorGetter: { $0.secondaryLabel }
        )

        super.init(corner: .init(radius: .fixed(8)))

        borderWidth = 1
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(8))
    }

    override func configureTheme(_ theme: VATheme) {
        borderUIColor = theme.secondaryLabel
    }
}
