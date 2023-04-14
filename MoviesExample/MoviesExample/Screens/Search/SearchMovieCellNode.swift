//
//  SearchMovieCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 14.04.2023.
//

import VATextureKit

final class SearchMovieCellNode: VACellNode {
    private let titleTextNode: VATextNode
    private let imageNode: VANetworkImageNode
    private lazy var separatorNode = ASDisplayNode()
        .sized(height: 1)

    init(viewModel: SearchMovieCellNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            textStyle: .headline
        ).flex(shrink: 0.1)
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image?.getImagePath(width: 200),
            contentMode: .scaleAspectFill,
            size: CGSize(width: 32, height: 48),
            cornerRadius: 4,
            cornerRoundingType: .precomposited
        ))

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            Row(spacing: 16, cross: .center) {
                imageNode
                titleTextNode
            }
            .padding(.vertical(6), .horizontal(16))
            separatorNode
                .padding(.left(60), .right(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        separatorNode.backgroundColor = theme.opaqueSeparator
    }
}

final class SearchMovieCellNodeViewModel: CellViewModel {
    let title: String
    let image: String?

    init(listEntity source: ListMovieEntity) {
        self.title = source.title
        self.image = source.poster

        super.init(identity: source.id)
    }
}
