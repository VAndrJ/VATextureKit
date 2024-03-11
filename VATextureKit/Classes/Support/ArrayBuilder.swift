//
//  ArrayBuilder.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.03.2024.
//

import Foundation

public extension Array {
    
    init(@ArrayBuilder<Element> _ builder: () -> [Element]) {
        self = builder()
    }
}

@resultBuilder
public struct ArrayBuilder<Element> {

    public static func buildBlock() -> [Element] {
        []
    }

    public static func buildBlock<C: Collection>(_ contents: C...) -> [Element] where C.Element == Element {
        contents.flatMap { $0 }
    }

    public static func buildEither(first component: [Element]) -> [Element] {
        component
    }

    public static func buildEither(second component: [Element]) -> [Element] {
        component
    }

    public static func buildExpression(_ element: Element?) -> [Element] {
        element.map { [$0] } ?? []
    }

    public static func buildExpression(_ element: Element) -> [Element] {
        [element]
    }

    public static func buildExpression<C: Collection>(_ elements: C) -> [Element] where C.Element == Element {
        Array(elements)
    }

    public static func buildExpression<C: Collection>(_ elements: C) -> [Element] where C.Element == Optional<Element> {
        elements.compactMap { $0 }
    }

    public static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }
}
