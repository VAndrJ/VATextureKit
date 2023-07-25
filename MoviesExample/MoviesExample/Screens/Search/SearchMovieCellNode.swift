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
            fontStyle: .headline
        ).withAnimatedTransition(id: "title_\(viewModel.transitionId)").flex(shrink: 0.1)
        self.imageNode = VANetworkImageNode(data: .init(
            image: viewModel.image?.getImagePath(width: 500),
            contentMode: .scaleAspectFill,
            size: CGSize(width: 32, height: 48),
            cornerRadius: 4
        )).withAnimatedTransition(id: "image_\(viewModel.transitionId)")

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
        imageNode.backgroundColor = theme.systemGray6
    }
}

final class SearchMovieCellNodeViewModel: CellViewModel {
    let title: String
    let image: String?

    init(listEntity source: ListMovieEntity) {
        self.title = source.title
        self.image = source.poster

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
