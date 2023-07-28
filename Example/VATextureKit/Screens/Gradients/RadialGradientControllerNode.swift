//
//  RadialGradientControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class RadialGradientControllerNode: VASafeAreaDisplayNode {
    private lazy var scrollNode = VAScrollNode(data: .init())
    private lazy var centeredGradientNode = VARadialGradientNode(gradient: .centered)
    private lazy var topLeftGradientNode = VARadialGradientNode(gradient: .topLeft)
    private lazy var topRightGradientNode = VARadialGradientNode(gradient: .topRight)
    private lazy var bottomLeftGradientNode = VARadialGradientNode(gradient: .bottomLeft)
    private lazy var bottomRightGradientNode = VARadialGradientNode(gradient: .bottomRight)
    private lazy var customGradientNode = VARadialGradientNode(gradient: .custom(startPoint: CGPoint(x: 0.4, y: 0.4), endPoint: CGPoint(x: 0.6, y: 0.6)))
    private lazy var contentNodes = [
        centeredGradientNode,
        topLeftGradientNode,
        topRightGradientNode,
        bottomLeftGradientNode,
        bottomRightGradientNode,
        customGradientNode,
    ].map { $0.ratio(1) }
    
    override init() {
        super.init()
        
        scrollNode.layoutSpecBlock = { [weak self] in
            self?.scrollLayoutSpecThatFits($1) ?? ASLayoutSpec()
        }
    }
    
    override func layout() {
        super.layout()
        
        if bounds.width > bounds.height {
            scrollNode.scrollableDirections = .horizontal
        } else {
            scrollNode.scrollableDirections = .vertical
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    private func scrollLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
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
