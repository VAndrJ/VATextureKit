//
//  CGSize+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import UIKit

public extension CGSize {
    
    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        .init(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    static func / (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        .init(width: lhs.width / rhs, height: lhs.height / rhs)
    }

    static func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    static func + (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        .init(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    static func - (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        .init(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    @inline(__always) @inlinable var area: CGFloat { width * height }
    @inline(__always) @inlinable var ratio: CGFloat { width / height }

    init(same: CGFloat) {
        self.init(width: same, height: same)
    }
    
    func adding(width: CGFloat, height: CGFloat) -> CGSize {
        .init(width: self.width + width, height: self.height + height)
    }
    
    func adding(insets: UIEdgeInsets) -> CGSize {
        .init(width: width + insets.horizontal, height: height + insets.vertical)
    }
    
    func aspectMinBoundingMultiplier(for size: CGSize) -> CGFloat {
        min(size.height / height, size.width / width)
    }
    
    func aspectMaxBoundingMultiplier(for size: CGSize) -> CGFloat {
        max(size.height / height, size.width / width)
    }
}
