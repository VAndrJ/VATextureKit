//
//  ShimmerCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class ShimmerCellNode: VACellNode {
    let viewModel: ShimmerCellNodeViewModel
    let contentNode: ASDisplayNode

    init(viewModel: ShimmerCellNodeViewModel) {
        switch viewModel.kind {
        case .trending: self.contentNode = TrendingListShimmerNode(data: .init())
        case .movieDetails: self.contentNode = MovieDetailsShimmerNode(data: .init())
        case .homeCell: self.contentNode = HomeCellShimmerNode(data: .init())
        }
        self.viewModel = viewModel

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        contentNode
            .wrapped()
    }

    override func configureTheme(_ theme: VATheme) {
        switch viewModel.kind {
        case .movieDetails, .trending:
            backgroundColor = theme.systemBackground
        case .homeCell:
            break
        }
    }
}

class ShimmerCellNodeViewModel: CellViewModel {
    enum Kind: CaseIterable {
        case trending
        case movieDetails
        case homeCell
    }

    let kind: Kind

    init(kind: Kind) {
        self.kind = kind

        super.init()
    }
}

private final class MovieDetailsShimmerNode: VAShimmerNode {
    private let tag0Node = VAShimmerTileNode(corner: .init(radius: .fixed(8)))
        .sized(CGSize(width: 64, height: 34))
    private let tag1Node = VAShimmerTileNode(corner: .init(radius: .fixed(8)))
        .sized(CGSize(width: 96, height: 34))
    private let tag2Node = VAShimmerTileNode(corner: .init(radius: .fixed(8)))
        .sized(CGSize(width: 48, height: 34))
    private let description0Node = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(CGSize(width: 96, height: 18))
    private let description1Node = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(CGSize(width: 48, height: 18))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 12) {
            Row(spacing: 8) {
                tag0Node
                tag1Node
                tag2Node
            }
            Column(spacing: 4) {
                description0Node
                description1Node
            }
        }
        .padding(.vertical(12), .horizontal(16))
    }
}

private final class TrendingListShimmerNode: VAShimmerNode {
    private let imageNode = VAShimmerTileNode(corner: .init(radius: .fixed(16)))
        .sized(CGSize(width: 126, height: 78))
    private let titleNode = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(CGSize(width: 120, height: 20))
    private let descriptionNode = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(CGSize(width: 80, height: 16))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 16) {
            imageNode
            Column(spacing: 4, cross: .stretch) {
                titleNode
                descriptionNode
            }
            .flex(shrink: 0.1, grow: 1)
        }
        .padding(.all(16))
    }
}

private final class HomeCellShimmerNode: VAShimmerNode {
    private let sliderNode = VAShimmerTileNode(corner: .init(radius: .fixed(22)))
        .sized(height: 44)
    private let cardNode = HomeCellShimmerCardPartNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            sliderNode
            cardNode
                .maxConstrained(width: constrainedSize.min.width / 2.5)
                .padding(.top(16))
        }
        .padding(.vertical(8), .horizontal(16))
    }
}

private final class HomeCellShimmerCardPartNode: VADisplayNode {
    private let cardNode = VAShimmerTileNode(corner: .init(radius: .fixed(16)))
    private let ratingNode = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(width: 46, height: 18)
    private let titleNode = VAShimmerTileNode(corner: .init(radius: .fixed(2)))
        .sized(height: 18)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            cardNode
                .ratio(190 / 126)
            Row {
                ratingNode
                    .padding(.top(8))
            }
            titleNode
                .padding(.top(4))
        }
    }
}
