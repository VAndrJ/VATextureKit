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
        case .trending:
            self.contentNode = ShimmerTrendingListNode()
        case .movieDetails:
            self.contentNode = ShimmerMovieDetailsNode()
        case .homeCell:
            self.contentNode = ShimmerHomeCellNode()
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
        if isVisible {
            startAnimating()
        }
    }

    override func layout() {
        super.layout()

        if isVisible {
            startAnimating()
        }
    }

    override func didEnterVisibleState() {
        super.didEnterVisibleState()

        startAnimating()
    }

    override func didExitVisibleState() {
        super.didExitVisibleState()

        stopAnimating()
    }

    func startAnimating() {
        let light = theme.systemBackground.cgColor
        let alpha = theme.systemBackground.withAlphaComponent(0.16).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            x: -bounds.width,
            y: 0,
            width: 3 * bounds.width,
            height: bounds.height
        )
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0.4, 0.5, 0.6]
        layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        gradient.colors = [light, alpha, light]
        gradient.add(animation, forKey: "shimmer")
    }

    func stopAnimating() {
        layer.mask = nil
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

private final class ShimmerMovieDetailsNode: VADisplayNode {
    private let titleNode = ASDisplayNode()
        .sized(CGSize(width: 120, height: 24))
    private let descriptionNode = ASDisplayNode()
        .sized(CGSize(width: 46, height: 24))
    private let imageNode = ASDisplayNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8, cross: .stretch) {
            Column(spacing: 4) {
                titleNode
                descriptionNode
            }
            .padding(.left(16))
            imageNode
                .ratio(230 / 375)
                .padding(.top(4))
        }
        .padding(.vertical(16))
    }

    override func configureTheme(_ theme: VATheme) {
        imageNode.backgroundColor = theme.systemGray6
        titleNode.backgroundColor = theme.systemGray6
        descriptionNode.backgroundColor = theme.systemGray6
    }
}

private final class ShimmerTrendingListNode: VADisplayNode {
    private let imageNode = ASDisplayNode()
        .sized(CGSize(width: 126, height: 78))
        .apply {
            $0.cornerRadius = 16
        }
    private let titleNode = ASDisplayNode()
        .sized(CGSize(width: 120, height: 20))
    private let descriptionNode = ASDisplayNode()
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

    override func configureTheme(_ theme: VATheme) {
        imageNode.backgroundColor = theme.systemGray6
        titleNode.backgroundColor = theme.systemGray6
        descriptionNode.backgroundColor = theme.systemGray6
    }
}

private final class ShimmerHomeCellNode: VADisplayNode {
    private let sliderNode = ASDisplayNode()
        .sized(height: 44)
        .apply {
            $0.cornerRadius = 22
        }
    private let cardNode = ShimmerHomeListMovieNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            sliderNode
            cardNode
                .maxConstrained(width: constrainedSize.min.width / 2.5)
                .padding(.top(16))
        }
        .padding(.vertical(8), .horizontal(16))
    }

    override func configureTheme(_ theme: VATheme) {
        sliderNode.backgroundColor = theme.systemGray6
    }
}

private final class ShimmerHomeListMovieNode: VADisplayNode {
    private let cardNode = ASDisplayNode()
        .apply {
            $0.cornerRadius = 16
        }
    private let ratingNode = ASDisplayNode()
        .sized(width: 46, height: 18)
    private let titleNode = ASDisplayNode()
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

    override func configureTheme(_ theme: VATheme) {
        cardNode.backgroundColor = theme.systemGray6
        ratingNode.backgroundColor = theme.systemGray6
        titleNode.backgroundColor = theme.systemGray6
    }
}
