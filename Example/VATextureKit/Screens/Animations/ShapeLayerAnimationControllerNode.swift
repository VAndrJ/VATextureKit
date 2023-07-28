//
//  ShapeLayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 27.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class ShapeLayerAnimationControllerNode: VASafeAreaDisplayNode {
    private lazy var fillColorExampleNode = FillColorExampleNode()
    private lazy var pathExampleNode = PathExampleNode()
    private lazy var strokeColorExampleNode = StrokeColorExampleNode()
    private lazy var strokeEndExampleNode = StrokeEndExampleNode()
    private lazy var lineDashExampleNode = LineDashExampleNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 32, cross: .stretch) {
                fillColorExampleNode
                pathExampleNode
                strokeColorExampleNode
                strokeEndExampleNode
                lineDashExampleNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

// swiftlint:disable force_cast
private class FillColorExampleNode: VADisplayNode {
    private lazy var exampleNode = ASDisplayNode(layerBlock: { CAShapeLayer() })
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .fillColor(from: .orange, to: .cyan),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        (exampleNode.layer as! CAShapeLayer).path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class PathExampleNode: VADisplayNode {
    private lazy var exampleNode = ASDisplayNode(layerBlock: {
        CAShapeLayer().apply {
            $0.fillColor = UIColor.orange.cgColor
        }
    }).sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .path(
                from: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 20)).cgPath,
                to: {
                    let path = UIBezierPath()
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 60, y: 10))
                    path.addLine(to: CGPoint(x: 100, y: 0))
                    path.addLine(to: CGPoint(x: 150, y: 64))
                    path.close()
                    return path.cgPath
                }()
            ),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class StrokeColorExampleNode: VADisplayNode {
    private lazy var exampleNode = ASDisplayNode(layerBlock: {
        CAShapeLayer().apply {
            $0.lineWidth = 10
        }
    }).sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .strokeColor(from: .orange, to: .cyan),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        (exampleNode.layer as! CAShapeLayer).path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class StrokeEndExampleNode: VADisplayNode {
    private lazy var exampleNode = ASDisplayNode(layerBlock: {
        CAShapeLayer().apply {
            $0.lineWidth = 32
            $0.strokeColor = UIColor.orange.cgColor
        }
    }).sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .lineWidth(from: 32, to: 1),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        (exampleNode.layer as! CAShapeLayer).path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class LineDashExampleNode: VADisplayNode {
    private lazy var exampleNode = ASDisplayNode(layerBlock: {
        CAShapeLayer().apply {
            $0.lineWidth = 2
            $0.strokeColor = UIColor.orange.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineDashPattern = [4, 4]
            $0.lineJoin = .round
        }
    }).sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .lineDashPhase(from: 0, to: 100),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 50, y: 32))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 150, y: 64))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 300, y: 32))
        path.close()
        (exampleNode.layer as! CAShapeLayer).path = path.cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}
