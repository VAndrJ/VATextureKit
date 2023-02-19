//
//  LayoutSpecBuilder.swift
//  VATextureKit
//
//  Created by VAndrJ on 19.02.2023.
//

import AsyncDisplayKit

@resultBuilder
public struct LayoutSpecBuilder {

    public static func buildBlock() -> [ASLayoutElement] {
        [ASLayoutSpec()]
    }

    public static func buildBlock(_ components: ASLayoutElement) -> [ASLayoutElement] {
        [components]
    }

    public static func buildBlock(_ components: [ASLayoutElement]) -> [ASLayoutElement] {
        components
    }

    public static func buildBlock(_ components: ASLayoutElement...) -> [ASLayoutElement] {
        components
    }

    public static func buildBlock(_ components: Any...) -> [ASLayoutElement] {
        var data: [ASLayoutElement] = []
        func append(element: Any) {
            switch element {
            case let element as ASLayoutElement:
                data.append(element)
            case let elements as [ASLayoutElement]:
                data.append(contentsOf: elements)
            case let elements as [[ASLayoutElement]]:
                data.append(contentsOf: elements.flatMap { $0 })
            default:
                assertionFailure(String(describing: element))
            }
        }
        components.forEach(append(element:))
        return data
    }

    public static func buildIf(_ content: [ASLayoutElement]) -> [ASLayoutElement] { // unused:ignore
        content
    }

    public static func buildOptional(_ component: [ASLayoutElement]?) -> [ASLayoutElement] { // unused:ignore
        component ?? []
    }

    public static func buildEither(first component: [ASLayoutElement]) -> [ASLayoutElement] {
        component
    }

    public static func buildEither(second component: [ASLayoutElement]) -> [ASLayoutElement] {
        component
    }
}
