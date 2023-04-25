//
//  MovieDetailsTitleCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieDetailsTitleCellNode: VACellNode {
    private let titleTextNode: VATextNode
    private let yearTextNode: VATextNode
    private let ratingNode: RatingNode

    init(viewModel: MovieDetailsTitleCellNodeViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title, fontStyle: .headline)
        self.yearTextNode = VATextNode(
            text: viewModel.year,
            maximumNumberOfLines: 1,
            themeColor: { $0.secondaryLabel }
        )
        self.ratingNode = RatingNode(rating: viewModel.rating)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 4, cross: .stretch) {
            titleTextNode
            Row(spacing: 4, main: .spaceBetween, cross: .center) {
                yearTextNode
                    .flex(shrink: 0.1)
                ratingNode
            }
        }
        .padding(.top(16), .horizontal(16), .bottom(8))
    }
}

final class MovieDetailsTitleCellNodeViewModel: CellViewModel {
    let title: String
    let year: String
    let rating: Double

    init(movie source: MovieEntity) {
        self.title = source.title
        self.year = source.year
        self.rating = source.rating

        super.init()
    }
}
