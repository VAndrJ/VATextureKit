//
//  CGSize+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import UIKit

public extension CGSize {
    
    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func + (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    init(same: CGFloat) {
        self.init(width: same, height: same)
    }
    
    func adding(dWidth: CGFloat, dHeight: CGFloat) -> CGSize {
        CGSize(width: width + dWidth, height: height + dHeight)
    }
    
    func adding(insets: UIEdgeInsets) -> CGSize {
        CGSize(width: width + insets.horizontal, height: height + insets.vertical)
    }
    
    func aspectMinBoundingMultiplier(for size: CGSize) -> CGFloat {
        min(size.height / height, size.width / width)
    }
    
    func aspectMaxBoundingMultiplier(for size: CGSize) -> CGFloat {
        max(size.height / height, size.width / width)
    }
}
