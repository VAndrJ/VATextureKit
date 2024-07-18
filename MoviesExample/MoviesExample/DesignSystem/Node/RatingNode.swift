//
//  RatingNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKit

final class RatingNode: VADisplayNode {
    private let percentTextNode: VATextNode
    private let indicatorNode: RatingIndicatorNode

    init(rating: Double) {
        self.percentTextNode = VATextNode(
            text: L.rating_percent(Int(rating.rounded(.up))),
            fontStyle: .footnote,
            maximumNumberOfLines: 1,
            colorGetter: { $0.secondaryLabel }
        )
        self.indicatorNode = RatingIndicatorNode(context: .init(rating: rating))
            .sized(CGSize(same: 16))

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 4, cross: .center) {
            indicatorNode
            percentTextNode
        }
    }
}

final private class RatingIndicatorNode: VADisplayNode {
    struct Context {
        let rating: Double
        let lineWidth: CGFloat
        let withBacking: Bool
        let startAngle: CGFloat

        init(
            rating: Double,
            lineWidth: CGFloat = 2,
            withBacking: Bool = true,
            startAngle: CGFloat = -.pi / 2
        ) {
            self.rating = max(1, rating)
            self.lineWidth = lineWidth
            self.withBacking = withBacking
            self.startAngle = startAngle
        }
    }

    private let shapeLayer = CAShapeLayer()
    private lazy var backingShapeLayer = CAShapeLayer()
    private let context: Context

    init(context: Context) {
        self.context = context

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        if context.withBacking {
            backingShapeLayer.lineWidth = context.lineWidth
            backingShapeLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(backingShapeLayer)
        }
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = context.lineWidth
        layer.addSublayer(shapeLayer)
    }

    override func layout() {
        super.layout()

        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - context.lineWidth) / 2
        let startAngle = context.startAngle
        let endAngle: CGFloat = 2 * .pi * context.rating / 100 + context.startAngle
        let getPath = curry(UIBezierPath.init)(arcCenter)(radius)(startAngle)(endAngle)
        shapeLayer.path = getPath(true).cgPath
        if context.withBacking {
            backingShapeLayer.path = getPath(false).cgPath
        }
    }

    override func configureTheme(_ theme: VATheme) {
        switch context.rating {
        case ..<40:
            if context.withBacking {
                backingShapeLayer.strokeColor = theme.systemRed.withAlphaComponent(0.16).cgColor
            }
            shapeLayer.strokeColor = theme.systemRed.cgColor
        case 40..<80:
            if context.withBacking {
                backingShapeLayer.strokeColor = theme.systemOrange.withAlphaComponent(0.16).cgColor
            }
            shapeLayer.strokeColor = theme.systemOrange.cgColor
        default:
            if context.withBacking {
                backingShapeLayer.strokeColor = theme.systemGreen.withAlphaComponent(0.16).cgColor
            }
            shapeLayer.strokeColor = theme.systemGreen.cgColor
        }
    }
}
