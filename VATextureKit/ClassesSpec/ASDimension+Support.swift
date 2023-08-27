//
//  ASDimension+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

public extension ASDimension {
    /// A predefined `ASDimension` constant in Swift way.
    static let auto = ASDimensionAuto

    /// Creates an `ASDimension` instance with a specific value in points.
    ///
    /// - Parameter value: The value in `points` as a `CGFloat`.
    /// - Returns: An `ASDimension` instance with the specified value in points.
    static func points(_ value: CGFloat) -> ASDimension {
        ASDimension(unit: .points, value: value)
    }

    /// Creates an `ASDimension` instance with a percentage fraction of the available size.
    ///
    /// - Parameter percent: The percentage fraction as a `CGFloat`. The value must be between 0 and 100.
    /// - Returns: An `ASDimension` instance with the specified percentage fraction of the available size.
    static func fraction(percent: CGFloat) -> ASDimension {
        assert(0...100 ~= percent, "ASDimension fraction percent \(percent) must be between 0 and 100.")

        return fraction(max(0, min(100, percent)) / 100)
    }

    /// Creates an `ASDimension` instance with a fraction value and unit.
    ///
    /// - Parameter value: The value as a `CGFloat`.
    /// - Returns: An `ASDimension` instance with the specified `fraction` unit value.
    static func fraction(_ value: CGFloat) -> ASDimension {
        ASDimension(unit: .fraction, value: value)
    }
}

extension ASDimension: Equatable {
    
    public static func == (lhs: ASDimension, rhs: ASDimension) -> Bool {
        lhs.unit == rhs.unit && lhs.value == rhs.value
    }
}
