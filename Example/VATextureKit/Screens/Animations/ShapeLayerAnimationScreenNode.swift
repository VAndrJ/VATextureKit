//
//  ShapeLayerAnimationScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 27.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ShapeLayerAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class ShapeLayerAnimationScreenNode: ScreenNode {
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

private class FillColorExampleNode: DisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(fillColor: theme.systemOrange))
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .fillColor(from: theme.systemOrange, to: theme.systemIndigo),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        exampleNode.layer.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class PathExampleNode: DisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(fillColor: theme.systemOrange))
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .path(
                from: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 20)),
                to: {
                    let path = UIBezierPath()
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 60, y: 10))
                    path.addLine(to: CGPoint(x: 100, y: 0))
                    path.addLine(to: CGPoint(x: 150, y: 64))
                    path.close()
                    return path
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

private class StrokeColorExampleNode: DisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: theme.systemOrange))
        .apply {
            $0.setLineWidth(10)
        }
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .strokeColor(from: theme.systemOrange, to: theme.systemIndigo),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
    }

    override func layout() {
        super.layout()

        exampleNode.layer.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class StrokeEndExampleNode: DisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: theme.systemOrange))
        .apply {
            $0.setLineWidth(32)
        }
        .sized(height: 64)

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

        exampleNode.layer.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class LineDashExampleNode: DisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: theme.systemOrange))
        .apply {
            $0.setLineWidth(2)
            $0.setLineDashPattern([4, 4])
            $0.setLineJoin(.round)
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 50, y: 32))
            path.addLine(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 150, y: 64))
            path.addLine(to: CGPoint(x: 200, y: 0))
            path.addLine(to: CGPoint(x: 300, y: 32))
            path.close()
            $0.setPath(path)
        }
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .lineDashPhase(from: 0, to: 80),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            timingFunction: .linear,
            continueFromCurrent: true
        )
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}
