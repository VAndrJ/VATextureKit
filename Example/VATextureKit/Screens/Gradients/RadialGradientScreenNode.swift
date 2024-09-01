//
//  RadialGradientScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct RadialGradientNavigationIdentity: DefaultNavigationIdentity {}

final class RadialGradientScreenNode: ScrollScreenNode, @unchecked Sendable {
    private lazy var centeredGradientNode = VARadialGradientNode(gradient: .centered)
    private lazy var topLeftGradientNode = VARadialGradientNode(gradient: .topLeft)
    private lazy var topRightGradientNode = VARadialGradientNode(gradient: .topRight)
    private lazy var bottomLeftGradientNode = VARadialGradientNode(gradient: .bottomLeft)
    private lazy var bottomRightGradientNode = VARadialGradientNode(gradient: .bottomRight)
    private lazy var customGradientNode = VARadialGradientNode(gradient: .custom(startPoint: CGPoint(xy: 0.4), endPoint: CGPoint(xy: 0.6)))
    private lazy var contentNodes = [
        centeredGradientNode,
        topLeftGradientNode,
        topRightGradientNode,
        bottomLeftGradientNode,
        bottomRightGradientNode,
        customGradientNode,
    ].map { $0.ratio(1) }
    
    override func layout() {
        super.layout()
        
        if bounds.width > bounds.height {
            scrollNode.scrollableDirections = .horizontal
        } else {
            scrollNode.scrollableDirections = .vertical
        }
    }

    override func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        (constrainedSize.min.width > constrainedSize.min.height).fold {
            Column {
                contentNodes
            }
        } _: {
            Row {
                contentNodes
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
        centeredGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        customGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
    }
}
