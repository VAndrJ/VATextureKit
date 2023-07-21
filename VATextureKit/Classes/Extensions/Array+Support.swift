//
//  Array+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 21.07.2023.
//

import Foundation

public extension Array where Element: AdditiveArithmetic {

    static func + (lhs: Self, rhs: Element) -> Self {
        return lhs.map { $0 + rhs }
    }
}
