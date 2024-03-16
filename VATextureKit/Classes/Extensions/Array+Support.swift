//
//  Array+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 21.07.2023.
//

import Foundation

public extension Array where Element: AdditiveArithmetic {

    static func + (lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 + rhs }
    }

    static func - (lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 - rhs }
    }
}

public extension Array {

    subscript(at index: Int) -> Element? {
        guard 0 <= index && index < count else {
            return nil
        }

        return self[index]
    }

    subscript(at indexPath: IndexPath) -> Element? {
        guard 0 <= indexPath.item && indexPath.item < count else {
            return nil
        }

        return self[indexPath.item]
    }
}

public extension Array where Element: Collection, Element.Index == Int {

    subscript(at indexPath: IndexPath) -> Element.Element? {
        guard 0 <= indexPath.section && indexPath.section < count, self[indexPath.section].indices.contains(indexPath.item) else {
            return nil
        }

        return self[indexPath.section][indexPath.item]
    }
}
