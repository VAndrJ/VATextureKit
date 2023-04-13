//
//  MovieCardCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

@MainActor
final class MovieCardNode: VADisplayNode {
    struct DTO {
        let image: String?
        let title: String
        let rating: Double
    }

    private let coverImageNode: VANetworkImageNode
    private let titleTextNode: VATextNode
    private let ratingNode: RatingNode

    init(data: DTO) {
        self.coverImageNode = VANetworkImageNode(data: .init(
            image: data.image?.getImagePath(width: 500),
            contentMode: .scaleAspectFill,
            cornerRadius: 16
        )).flex(shrink: 0.1, grow: 1)
        self.titleTextNode = VATextNode(
            text: data.title,
            textStyle: .footnote
        )
        self.ratingNode = RatingNode(rating: data.rating)

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
}

extension MovieCardNode.DTO {

    init(listMovie source: ListMovieEntity) {
        self.init(
            image: source.image,
            title: source.title,
            rating: source.rating
        )
    }
}
