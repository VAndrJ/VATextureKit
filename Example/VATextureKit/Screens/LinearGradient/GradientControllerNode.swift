//
//  GradientControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class GradientControllerNode: VASafeAreaDisplayNode {
    let scrollNode = VABaseScrollNode()
    let verticalGradientNode = VALinearGradientNode(gradient: .vertical)
    let horizontalGradientNode = VALinearGradientNode(gradient: .horizontal)
    let topLeftToBottomRightGradientNode = VALinearGradientNode(gradient: .diagonal(.topLeftToBottomRight))
    let topRightToBottomLeftGradientNode = VALinearGradientNode(gradient: .diagonal(.topRightToBottomLeft))
    let bottomLeftToTopRightGradientNode = VALinearGradientNode(gradient: .diagonal(.bottomLeftToTopRight))
    let bottomRightToTopLeftGradientNode = VALinearGradientNode(gradient: .diagonal(.bottomRightToTopLeft))
    let customGradientNode = VALinearGradientNode(gradient: .custom(startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 1, y: 1)))
    
    override init() {
        super.init()
        
        scrollNode.layoutSpecBlock = { [verticalGradientNode, horizontalGradientNode, topLeftToBottomRightGradientNode, topRightToBottomLeftGradientNode, bottomLeftToTopRightGradientNode, bottomRightToTopLeftGradientNode, customGradientNode] _, size in // swiftlint:disable:this line_length
            let content = [
                verticalGradientNode
                    .ratio(1),
                horizontalGradientNode
                    .ratio(1),
                topLeftToBottomRightGradientNode
                    .ratio(1),
                topRightToBottomLeftGradientNode
                    .ratio(1),
                bottomLeftToTopRightGradientNode
                    .ratio(1),
                bottomRightToTopLeftGradientNode
                    .ratio(1),
                customGradientNode
                    .ratio(1),
            ]
            if size.min.width > size.min.height {
                return Row {
                    content
                }
            } else {
                return Column {
                    content
                }
            }
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
        backgroundColor = theme.systemBackground
        verticalGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        horizontalGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topLeftToBottomRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        topRightToBottomLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomLeftToTopRightGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        bottomRightToTopLeftGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
        customGradientNode.update(colors: (theme.label, 0), (theme.systemBackground, 1))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }
}

open class VABaseScrollNode: ASScrollNode {
    
    public override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
        view.contentInsetAdjustmentBehavior = .never
    }
}

public extension CGSize {
    
    init(same: CGFloat) {
        self.init(width: same, height: same)
    }
}
