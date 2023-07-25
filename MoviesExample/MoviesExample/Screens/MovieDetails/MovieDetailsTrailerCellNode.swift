//
//  MovieDetailsTrailerCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieDetailsTrailerCellNode: VACellNode {
    private let imageNode: VANetworkImageNode

    init(viewModel: MovieDetailsTrailerCellNodeViewModel) {
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image?.getImagePath(width: 500),
            contentMode: .scaleAspectFill
        ))

        super.init()

        transitionAnimationId = "image_\(viewModel.transitionId)"
        transitionAnimation = .default(additions: .init(opacity: .skip))
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(230 / 375)
    }

    override func configureTheme(_ theme: VATheme) {
        imageNode.backgroundColor = theme.systemGray6
    }
}

final class MovieDetailsTrailerCellNodeViewModel: CellViewModel {
    let image: String?

    init(image: String?, transitionId: String?) {
        self.image = image

        super.init(identity: image ?? UUID().uuidString)
    }

    init(movie source: MovieEntity) {
        self.image = source.backdropPath

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }

    init(listMovie source: ListMovieEntity) {
        self.image = source.backdropPath

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
