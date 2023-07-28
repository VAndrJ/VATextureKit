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

private class FillColorExampleNode: VADisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(fillColor: .orange))
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

        exampleNode.layer.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class PathExampleNode: VADisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(fillColor: .orange))
        .sized(height: 64)

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
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: .orange))
        .apply {
            $0.setLineWidth(10)
        }
        .sized(height: 64)

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

        exampleNode.layer.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        exampleNode
            .wrapped()
    }
}

private class StrokeEndExampleNode: VADisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: .orange))
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

private class LineDashExampleNode: VADisplayNode {
    private lazy var exampleNode = VAShapeNode(data: .init(strokeColor: .orange))
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
