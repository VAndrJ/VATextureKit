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

    func isRoughlyEqual(to other: CGFloat, tolerance: CGFloat) -> Bool {
        (self - tolerance) <= other && other <= (self + tolerance)
    }

    @MainActor
    func pixelRounded(_ rule: FloatingPointRoundingRule) -> CGFloat {
        pixelRounded(rule, scale: UIScreen.main.scale)
    }

    func pixelRounded(_ rule: FloatingPointRoundingRule, scale: CGFloat) -> CGFloat {
        (self * scale).rounded(rule) / scale
    }

    @MainActor
    func isPixelEqual(to other: CGFloat) -> Bool {
        isPixelEqual(to: other, scale: UIScreen.main.scale)
    }

    func isPixelEqual(to other: CGFloat, scale: CGFloat) -> Bool {
        isRoughlyEqual(to: other, tolerance: 1 / scale)
    }
}
