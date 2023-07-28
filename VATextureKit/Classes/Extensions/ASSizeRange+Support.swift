//
//  ASSizeRange+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import AsyncDisplayKit

public extension ASSizeRange {
    /// A predefined `ASSizeRangeUnconstrained` constant in Swift way.
    static let unconstrained = ASSizeRangeUnconstrained
    /// A predefined `ASSizeRangeZero` constant in Swift way.
    static let zero = ASSizeRangeZero

    /// Creates an `ASSizeRange` instance with a specific width and height range.
    ///
    /// - Parameters:
    ///   - width: The closed range of `CGFloat` values representing the allowed width range.
    ///   - height: The closed range of `CGFloat` values representing the allowed height range.
    init(width: ClosedRange<CGFloat>, height: ClosedRange<CGFloat>) {
        self.init(
            min: CGSize(width: width.lowerBound, height: height.lowerBound),
            max: CGSize(width: width.upperBound, height: height.upperBound)
        )
    }

    /// Creates an `ASSizeRange` instance with a fixed width and a specific height range.
    ///
    /// - Parameters:
    ///   - width: The fixed width value as a `CGFloat`.
    ///   - height: The closed range of `CGFloat` values representing the allowed height range.
    init(width: CGFloat, height: ClosedRange<CGFloat>) {
        self.init(
            min: CGSize(width: width, height: height.lowerBound),
            max: CGSize(width: width, height: height.upperBound)
        )
    }

    /// Creates an `ASSizeRange` instance with a specific width range and a fixed height.
    ///
    /// - Parameters:
    ///   - width: The closed range of `CGFloat` values representing the allowed width range.
    ///   - height: The fixed height value as a `CGFloat`.
    init(width: ClosedRange<CGFloat>, height: CGFloat) {
        self.init(
            min: CGSize(width: width.lowerBound, height: height),
            max: CGSize(width: width.upperBound, height: height)
        )
    }

    /// Creates an `ASSizeRange` instance with a fixed width and height.
    ///
    /// - Parameters:
    ///   - width: The fixed width value as a `CGFloat`.
    ///   - height: The fixed height value as a `CGFloat`.
    init(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        self.init(
            min: size,
            max: size
        )
    }
}
