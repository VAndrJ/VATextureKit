//
//  VAPadding.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

public enum VAPadding {
    case top(CGFloat)
    case left(CGFloat)
    case bottom(CGFloat)
    case right(CGFloat)
    case horizontal(CGFloat)
    case vertical(CGFloat)
    case all(CGFloat)
    case topLeft(CGFloat)
    case topRight(CGFloat)
    case bottomLeft(CGFloat)
    case bottomRight(CGFloat)
    case custom(CGFloat, CGFloat, CGFloat, CGFloat)
    case custom(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
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
