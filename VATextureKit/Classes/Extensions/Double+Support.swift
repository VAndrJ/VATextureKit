//
//  Double+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

import Foundation

public extension Double {

    func isRoughlyEqual(to other: Double, tolerance: Double) -> Bool {
        (self - tolerance) <= other && other <= (self + tolerance)
    }
}

public extension CGFloat {

    @MainActor
    func pixelRounded(_ rule: FloatingPointRoundingRule) -> CGFloat {
        (self * UIScreen.main.scale).rounded(rule) / UIScreen.main.scale
    }

    func isRoughlyEqual(to other: CGFloat, tolerance: CGFloat) -> Bool {
        (self - tolerance) <= other && other <= (self + tolerance)
    }

    @MainActor
    func isPixelEqual(to other: CGFloat) -> Bool {
        isRoughlyEqual(to: other, tolerance: 1 / UIScreen.main.scale)
    }
}
