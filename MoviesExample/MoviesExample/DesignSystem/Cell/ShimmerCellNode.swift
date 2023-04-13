//
//  ShimmerCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

@MainActor
final class ShimmerCellNode: VACellNode {
    let viewModel: ShimmerCellNodeViewModel
    let contentNode: ASDisplayNode

    init(viewModel: ShimmerCellNodeViewModel) {
        switch viewModel.kind {
        case .trending:
            self.contentNode = ShimmerTrendingListNode()
        case .movieDetails:
            self.contentNode = ShimmerMovieDetailsNode()
        }
        self.viewModel = viewModel

        super.init()

        contentNode.enableSubtreeRasterization()
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

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        contentNode
            .wrapped()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        if isVisible {
            startAnimating()
        }
    }
}

class ShimmerCellNodeViewModel: CellViewModel {
    enum Kind {
        case trending
        case movieDetails
    }

    let kind: Kind

    init(kind: Kind) {
        self.kind = kind

        super.init()
    }
}

@MainActor
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

@MainActor
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
