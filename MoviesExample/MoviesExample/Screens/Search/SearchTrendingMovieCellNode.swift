//
//  SearchTrendingMovieCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class SearchTrendingMovieCellNode: VACellNode {
    private let titleTextNode: VATextNode
    private let descriptionTextNode: VATextNode
    private let imageNode: VANetworkImageNode

    init(viewModel: SearchTrendingMovieCellNodeViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title)
        self.descriptionTextNode = VATextNode(
            text: viewModel.description,
            textStyle: .footnote,
            themeColor: { $0.secondaryLabel }
        )
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image,
            contentMode: .scaleAspectFill,
            size: CGSize(width: 126, height: 78),
            cornerRadius: 16,
            cornerRoundingType: .precomposited
        ))

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 16) {
            imageNode
            Column(spacing: 4, cross: .stretch) {
                titleTextNode
                descriptionTextNode
            }
            .flex(shrink: 0.1, grow: 1)
        }
        .padding(.all(16))
    }
}

final class SearchTrendingMovieCellNodeViewModel: CellViewModel {
    let title: String
    let description: String
    let image: String?

    init(id: Int, title: String, description: String, image: String?) {
        self.title = title
        self.description = description
        self.image = image

        super.init(identity: id)
    }

    init(listEntity source: ListMovieEntity) {
        self.title = source.title
        self.description = source.overview
        self.image = source.image.flatMap { $0.getImagePath(width: 500) }

        super.init(identity: source.id)
    }
}
