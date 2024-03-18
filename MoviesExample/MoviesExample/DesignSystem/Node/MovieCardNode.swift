//
//  MovieCardNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieCardNode: VADisplayNode {
    private let coverImageNode: VANetworkImageNode
    private let titleTextNode: VATextNode
    private let ratingNode: RatingNode

    init(viewModel: MovieCardNodeViewModel) {
        self.coverImageNode = VANetworkImageNode(
            image: viewModel.image?.getImagePath(width: 500),
            contentMode: .scaleAspectFill,
            corner: .init(radius: .fixed(16), clipsToBounds: true)
        )
        .flex(shrink: 0.1, grow: 1)
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .footnote
        )
        .withAnimatedTransition(id: "title_\(viewModel.transitionId)")
        self.ratingNode = RatingNode(rating: viewModel.rating)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 4, cross: .stretch) {
            coverImageNode
                .ratio(190 / 126)
            ratingNode
                .padding(.top(4))
            titleTextNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        coverImageNode.backgroundColor = theme.systemGray5
    }
}

final class MovieCardNodeViewModel: CellViewModel {
    let image: String?
    let title: String
    let rating: Double

    init(listMovie source: ListMovieEntity) {
        self.image = source.poster
        self.title = source.title
        self.rating = source.rating

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
