//
//  LinearGradientScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct LinearGradientNavigationIdentity: DefaultNavigationIdentity {}

final class LinearGradientScreenNode: ScrollScreenNode, @unchecked Sendable {
    private lazy var verticalGradientNode = VALinearGradientNode(gradient: .vertical)
    private lazy var horizontalGradientNode = VALinearGradientNode(gradient: .horizontal)
    private lazy var topLeftToBottomRightGradientNode = VALinearGradientNode(gradient: .diagonal(.topLeftToBottomRight))
    private lazy var topRightToBottomLeftGradientNode = VALinearGradientNode(gradient: .diagonal(.topRightToBottomLeft))
    private lazy var bottomLeftToTopRightGradientNode = VALinearGradientNode(gradient: .diagonal(.bottomLeftToTopRight))
    private lazy var bottomRightToTopLeftGradientNode = VALinearGradientNode(gradient: .diagonal(.bottomRightToTopLeft))
    private lazy var customGradientNode = VALinearGradientNode(gradient: .custom(startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(xy: 1)))
    private lazy var contentNodes = [
        verticalGradientNode,
        horizontalGradientNode,
        topLeftToBottomRightGradientNode,
        topRightToBottomLeftGradientNode,
        bottomLeftToTopRightGradientNode,
        bottomRightToTopLeftGradientNode,
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
        verticalGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        horizontalGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topLeftToBottomRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topRightToBottomLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomLeftToTopRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomRightToTopLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        customGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
    }
}
