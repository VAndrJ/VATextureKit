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

public extension UIEdgeInsets {

    /// Creates a `UIEdgeInsets` instance based on an array of padding configurations.
    ///
    /// - Parameter paddings: An array of `VAPadding` representing the padding values for each edge of the insets.
    init(paddings: [VAPadding]) {
        var top: CGFloat = 0
        var left: CGFloat = 0
        var bottom: CGFloat = 0
        var right: CGFloat = 0
        paddings.forEach {
            switch $0 {
            case let .insets(insets):
                #if DEBUG
                assert(top.isZero && left.isZero && bottom.isZero && right.isZero)
                #endif
                top = insets.top
                left = insets.left
                bottom = insets.bottom
                right = insets.right
            case let .custom(paddingTop, paddingLeft, paddingBottom, paddingRight):
                #if DEBUG
                assert(top.isZero && left.isZero && bottom.isZero && right.isZero)
                #endif
                top = paddingTop
                left = paddingLeft
                bottom = paddingBottom
                right = paddingRight
            case let .vertical(padding):
                #if DEBUG
                assert(top.isZero && bottom.isZero)
                #endif
                top = padding
                bottom = padding
            case let .horizontal(padding):
                #if DEBUG
                assert(left.isZero && right.isZero)
                #endif
                left = padding
                right = padding
            case let .all(padding):
                #if DEBUG
                assert(top.isZero && left.isZero && bottom.isZero && right.isZero)
                #endif
                top = padding
                left = padding
                bottom = padding
                right = padding
            case let .bottom(padding):
                #if DEBUG
                assert(bottom.isZero)
                #endif
                bottom = padding
            case let .top(padding):
                #if DEBUG
                assert(top.isZero)
                #endif
                top = padding
            case let .left(padding):
                #if DEBUG
                assert(left.isZero)
                #endif
                left = padding
            case let .right(padding):
                #if DEBUG
                assert(right.isZero)
                #endif
                right = padding
            case let .topLeft(padding):
                #if DEBUG
                assert(top.isZero && left.isZero)
                #endif
                top = padding
                left = padding
            case let .topRight(padding):
                #if DEBUG
                assert(top.isZero && right.isZero)
                #endif
                top = padding
                right = padding
            case let .bottomLeft(padding):
                #if DEBUG
                assert(left.isZero && bottom.isZero)
                #endif
                left = padding
                bottom = padding
            case let .bottomRight(padding):
                #if DEBUG
                assert(bottom.isZero && right.isZero)
                #endif
                bottom = padding
                right = padding
            }
        }
        
        self.init(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
}
