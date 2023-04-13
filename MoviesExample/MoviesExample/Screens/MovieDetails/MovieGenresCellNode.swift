//
//  MovieGenresCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class MovieGenresCellNode: VACellNode {
    private let genreNodes: [ASDisplayNode]

    init(viewModel: MovieGenresCellNodeViewModel) {
        self.genreNodes = viewModel.genres.map { GenreNode(genre: $0.name) }

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 8, wrap: .wrap, line: 8) {
            genreNodes
        }
        .padding(.vertical(12), .horizontal(16))
    }
}

final class MovieGenresCellNodeViewModel: CellViewModel {
    let genres: [GenreEntity]

    init(genres: [GenreEntity]) {
        self.genres = genres

        super.init()
    }
}
