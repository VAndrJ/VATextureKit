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
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }

    subscript(at indexPath: IndexPath) -> Element? {
        if 0 <= indexPath.item && indexPath.item < count {
            return self[indexPath.item]
        } else {
            return nil
        }
    }
}

public extension Array where Element: Collection, Element.Index == Int {

    subscript(at indexPath: IndexPath) -> Element.Element? {
        if 0 <= indexPath.section && indexPath.section < count, self[indexPath.section].indices.contains(indexPath.item) {
            return self[indexPath.section][indexPath.item]
        } else {
            return nil
        }
    }
}
