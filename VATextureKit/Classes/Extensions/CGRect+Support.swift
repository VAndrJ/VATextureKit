//
//  CGRect+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.07.2023.
//

import Foundation

public extension CGRect {
    var position: CGPoint { CGPoint(x: midX, y: midY) }

    init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }
}
