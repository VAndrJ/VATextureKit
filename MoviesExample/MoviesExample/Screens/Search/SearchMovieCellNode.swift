//
//  SearchMovieCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 14.04.2023.
//

import VATextureKit

final class SearchMovieCellNode: VACellNode, @unchecked Sendable {
    private let titleTextNode: VATextNode
    private let imageNode: VANetworkImageNode
    private lazy var separatorNode = ASDisplayNode()

    init(viewModel: SearchMovieCellNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            fontStyle: .headline
        )
        self.imageNode = VANetworkImageNode(
            image: viewModel.image?.getImagePath(width: 500),
            size: CGSize(width: 32, height: 48),
            contentMode: .scaleAspectFill,
            corner: .init(radius: .fixed(4), clipsToBounds: true)
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            Row(spacing: 16, cross: .center) {
                imageNode
                titleTextNode
                    .flex(shrink: 0.1)
            }
            .padding(.vertical(6), .horizontal(16))
            separatorNode
                .sized(height: 1)
                .padding(.left(60), .right(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        separatorNode.backgroundColor = theme.opaqueSeparator
        imageNode.backgroundColor = theme.systemGray6
    }
}

final class SearchMovieCellNodeViewModel: CellViewModel {
    let title: String
    let image: String?

    init(listEntity source: ListMovieEntity) {
        self.title = source.title
        self.image = source.backdropPath

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
