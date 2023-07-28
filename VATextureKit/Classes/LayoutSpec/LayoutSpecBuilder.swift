//
//  LayoutSpecBuilder.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// `LayoutSpecBuilder` is a result builder used to construct an array of `ASLayoutElement` objects for use in `Layout Spec`.
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
                assertionFailure("Failed element: \(String(describing: element)). Use only ASLayoutElements")
            }
        }
        components.forEach(append(element:))
        return data
    }

    public static func buildIf(_ content: [ASLayoutElement]) -> [ASLayoutElement] {
        content
    }

    public static func buildOptional(_ component: [ASLayoutElement]?) -> [ASLayoutElement] {
        component ?? []
    }

    public static func buildEither(first component: [ASLayoutElement]) -> [ASLayoutElement] {
        component
    }

    public static func buildEither(second component: [ASLayoutElement]) -> [ASLayoutElement] {
        component
    }
}
