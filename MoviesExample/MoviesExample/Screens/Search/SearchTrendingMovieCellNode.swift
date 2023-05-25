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
            fontStyle: .footnote,
            colorGetter: { $0.secondaryLabel }
        )
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image?.getImagePath(width: 200),
            contentMode: .scaleAspectFill,
            size: CGSize(width: 126, height: 78),
            cornerRadius: 16
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

    override func configureTheme(_ theme: VATheme) {
        imageNode.backgroundColor = theme.systemGray6
    }
}

final class SearchTrendingMovieCellNodeViewModel: CellViewModel {
    let title: String
    let description: String
    let image: String?

    init(listEntity source: ListMovieEntity) {
        self.title = source.title
        self.description = source.overview
        self.image = source.image

        super.init(identity: source.id)
    }
}
