//
//  MoviesSliderCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit
import Swiftional

@MainActor
final class MoviesSliderCellNode: VACellNode {
    private let titleTextNode: VATextNode
    private lazy var listNode = VAScrollNode(data: .init(
        scrollableDirections: ASScrollDirectionHorizontalDirections,
        alwaysBounceVertical: false,
        contentInset: UIEdgeInsets(horizontal: 16)
    ))
    private let movieNodes: [ASDisplayNode]

    init(viewModel: MoviesSliderCellNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.title,
            textStyle: .headline
        )
        self.movieNodes = viewModel.movies.map { movie in
            VAContainerButtonNode(
                child: MovieCardNode(data: .init(listMovie: movie)),
                onTap: viewModel.onSelect <<| movie
            )
        }

        super.init()

        listNode.layoutSpecBlock = { [weak self] _, size in
            self?.layoutSpecScroll(constrainedSize: size) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            listNode
        }
        .padding(.vertical(24))
    }

    func layoutSpecScroll(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 8) {
            movieNodes
                .sized(width: constrainedSize.min.width / 3)
        }
    }
}

final class MoviesSliderCellNodeViewModel: CellViewModel {
    let title: String
    let movies: [ListMovieEntity]
    let onSelect: (ListMovieEntity) -> Void

    init(title: String, movies: [ListMovieEntity], onSelect: @escaping (ListMovieEntity) -> Void) {
        self.title = title
        self.movies = movies
        self.onSelect = onSelect

        super.init()
    }
}
