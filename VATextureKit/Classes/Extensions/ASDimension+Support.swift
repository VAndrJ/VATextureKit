//
//  ASDimension+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

public extension ASDimension {
    static let auto = ASDimensionAuto

    static func points(_ value: CGFloat) -> ASDimension {
        ASDimension(unit: .points, value: value)
    }

    static func fraction(percent: CGFloat) -> ASDimension {
        assert(0...100 ~= percent, "ASDimension fraction percent \(percent) must be between 0 and 100.")
        return fraction(percent / 100)
    }

    static func fraction(_ value: CGFloat) -> ASDimension {
        ASDimension(unit: .fraction, value: value)
    }
}
