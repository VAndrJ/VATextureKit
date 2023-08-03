//
//  CGPoint+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

import UIKit

public extension CGPoint {

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    static func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    init(xy: Double) {
        self.init(x: xy, y: xy)
    }
}
