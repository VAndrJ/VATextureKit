//
//  GradientLayerAnimationScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 27.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct GradientLayerAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class GradientLayerAnimationScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var locationsExampleNode = _LocationsExampleNode()
    private lazy var colorsExampleNode = _ColorsExampleNode()
    private lazy var pointsExampleNode = _PointsExampleNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 32, cross: .stretch) {
                locationsExampleNode
                colorsExampleNode
                pointsExampleNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

private class _PointsExampleNode: VADisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VALinearGradientNode(gradient: .horizontal)
        .apply { $0.update(colors: (.green, 0), (.black, 0.5), (.green, 1)) }
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .startPoint(from: .init(x: 0, y: 0.5), to: .init(x: 0.5, y: 1)),
            duration: 2,
            repeatCount: .greatestFiniteMagnitude,
            autoreverses: true
        )
        exampleNode.animate(
            .endPoint(from: .init(x: 1, y: 0.5), to: .init(x: 0.5, y: 0)),
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

private class _ColorsExampleNode: VADisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VALinearGradientNode(gradient: .horizontal)
        .apply { $0.update(colors: (.green, 0), (.black, 0.5), (.green, 1)) }
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .colors(from: [.green, .black, .green], to: [.cyan, .white, .cyan]),
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

private class _LocationsExampleNode: VADisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VALinearGradientNode(gradient: .horizontal)
        .apply { $0.update(colors: (.green, 0), (.black, 0.2), (.green, 0.4)) }
        .sized(height: 64)

    override func didLoad() {
        super.didLoad()

        exampleNode.animate(
            .locations(from: [0, 0.2, 0.4], to: [0.6, 0.8, 1]),
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
