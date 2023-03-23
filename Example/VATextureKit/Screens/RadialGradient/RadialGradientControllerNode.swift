//
//  RadialGradientControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class RadialGradientControllerNode: VASafeAreaDisplayNode {
    let scrollNode = VABaseScrollNode()
    let centeredGradientNode = VARadialGradientNode(gradient: .centered)
    let topLeftGradientNode = VARadialGradientNode(gradient: .topLeft)
    let topRightGradientNode = VARadialGradientNode(gradient: .topRight)
    let bottomLeftGradientNode = VARadialGradientNode(gradient: .bottomLeft)
    let bottomRightGradientNode = VARadialGradientNode(gradient: .bottomRight)
    let customGradientNode = VARadialGradientNode(gradient: .custom(startPoint: CGPoint(x: 0.4, y: 0.4), endPoint: CGPoint(x: 0.6, y: 0.6)))
    
    override init() {
        super.init()
        
        scrollNode.layoutSpecBlock = { [weak self] _, constrainedSize in
            self?.layoutSpecScroll(constrainedSize) ?? ASLayoutSpec()
        }
    }
    
    override func layout() {
        super.layout()
        
        if bounds.width > bounds.height {
            scrollNode.scrollableDirections = [.left, .right]
        } else {
            scrollNode.scrollableDirections = [.up, .down]
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
    
    func layoutSpecScroll(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let content = [
            centeredGradientNode
                .ratio(1),
            topLeftGradientNode
                .ratio(1),
            topRightGradientNode
                .ratio(1),
            bottomLeftGradientNode
                .ratio(1),
            bottomRightGradientNode
                .ratio(1),
            customGradientNode
                .ratio(1),
        ]
        if constrainedSize.min.width > constrainedSize.min.height {
            return Row {
                content
            }
        } else {
            return Column {
                content
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }
}
