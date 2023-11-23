//
//  VAPadding.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

/// An enumeration that represents various padding configurations for layout elements.
public enum VAPadding {
    /// Padding only at the top of the layout element.
    case top(CGFloat)
    /// Padding only at the left of the layout element.
    case left(CGFloat)
    /// Padding only at the bottom of the layout element.
    case bottom(CGFloat)
    /// Padding only at the right of the layout element.
    case right(CGFloat)
    /// Horizontal padding, applied to both left and right of the layout element.
    case horizontal(CGFloat)
    /// Vertical padding, applied to both top and bottom of the layout element.
    case vertical(CGFloat)
    /// Uniform padding applied to all edges of the layout element: top, left, bottom, right
    case all(CGFloat)
    /// Padding at the top-left corner, applied to both top and left of the layout element.
    case topLeft(CGFloat)
    /// Padding at the top-right corner, applied to both top and right of the layout element.
    case topRight(CGFloat)
    /// Padding at the bottom-left corner, applied to both bottom and left of the layout element.
    case bottomLeft(CGFloat)
    /// Padding at the bottom-right corner, applied to both bottom and right of the layout element.
    case bottomRight(CGFloat)
    /// Custom padding with individual values for top, left, bottom, and right edges.
    case custom(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
    /// Padding defined using UIEdgeInsets.
    case insets(UIEdgeInsets)
}

extension UIEdgeInsets {

    init(paddings: [VAPadding]) {
        var top: CGFloat = 0
        var left: CGFloat = 0
        var bottom: CGFloat = 0
        var right: CGFloat = 0
        paddings.forEach {
            switch $0 {
            case let .insets(insets):
                top = insets.top
                left = insets.left
                bottom = insets.bottom
                right = insets.right
            case let .custom(paddingTop, paddingLeft, paddingBottom, paddingRight):
                top = paddingTop
                left = paddingLeft
                bottom = paddingBottom
                right = paddingRight
            case let .vertical(padding):
                top = padding
                bottom = padding
            case let .horizontal(padding):
                left = padding
                right = padding
            case let .all(padding):
                top = padding
                left = padding
                bottom = padding
                right = padding
            case let .bottom(padding):
                bottom = padding
            case let .top(padding):
                top = padding
            case let .left(padding):
                left = padding
            case let .right(padding):
                right = padding
            case let .topLeft(padding):
                top = padding
                left = padding
            case let .topRight(padding):
                top = padding
                right = padding
            case let .bottomLeft(padding):
                bottom = padding
                left = padding
            case let .bottomRight(padding):
                bottom = padding
                right = padding
            }
        }
        
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
