//
//  GenreNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class GenreNode: VADisplayNode {
    private let titleTextNode: VATextNode

    init(genre: String) {
        self.titleTextNode = VATextNode(
            text: genre,
            textStyle: .subhead,
            themeColor: { $0.secondaryLabel }
        )

        super.init()

        cornerRadius = 8
        borderWidth = 1
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(8))
    }

    override func configureTheme(_ theme: VATheme) {
        borderColor = theme.secondaryLabel.cgColor
    }
}
