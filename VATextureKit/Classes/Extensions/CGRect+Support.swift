//
//  CGRect+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.07.2023.
//

import Foundation

public extension CGRect {
    @inline(__always) @inlinable var area: CGFloat { size.area }
    @inline(__always) @inlinable var ratio: CGFloat { size.ratio }
    var position: CGPoint {
        get { .init(x: midX, y: midY) }
        set { origin = .init(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2) }
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }
}
