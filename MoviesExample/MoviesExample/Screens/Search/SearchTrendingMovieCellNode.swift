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
            .withAnimatedTransition(id: "title_\(viewModel.transitionId)")
        self.descriptionTextNode = VATextNode(
            text: viewModel.description,
            fontStyle: .footnote,
            colorGetter: { $0.secondaryLabel }
        )
        self.imageNode = VANetworkImageNode(
            image: viewModel.image?.getImagePath(width: 500),
            size: CGSize(width: 126, height: 78),
            contentMode: .scaleAspectFill,
            corner: .init(radius: .fixed(16), clipsToBounds: true)
        ).withAnimatedTransition(id: "image_\(viewModel.transitionId)", animation: .default(additions: .init(opacity: .skip)))

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 16) {
            imageNode
            Column(spacing: 4) {
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

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
