//
//  MovieDetailsTrailerCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieDetailsTrailerCellNode: VACellNode {
    private let imageNode: VANetworkImageNode
    private lazy var gradientNode = VALinearGradientNode(gradient: .vertical, blend: .multiply)

    init(viewModel: MovieDetailsTrailerCellNodeViewModel) {
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image,
            contentMode: .scaleAspectFill
        ))

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(230 / 375)
            .overlay(gradientNode)
    }

    override func configureTheme(_ theme: VATheme) {
        gradientNode.update(colors: (theme.systemBackground.withAlphaComponent(1), 0), (theme.darkText.withAlphaComponent(0.32), 1))
    }
}

final class MovieDetailsTrailerCellNodeViewModel: CellViewModel {
    let image: String?

    init(image: String?) {
        self.image = image.flatMap { $0.getImagePath(width: 500) }

        super.init()
    }
}
