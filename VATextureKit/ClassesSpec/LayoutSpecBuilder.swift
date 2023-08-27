//
//  LayoutSpecBuilder.swift
//  VATextureKitSpec
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// `LayoutSpecBuilder` is a result builder used to construct an array of `ASLayoutElement` objects for use in `Layout Spec`.
@resultBuilder
public struct LayoutSpecBuilder {

    public static func buildBlock(_ components: [ASLayoutElement]) -> [ASLayoutElement] {
        components
    }

    public static func buildBlock(_ components: [ASLayoutElement]...) -> [ASLayoutElement] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: ASLayoutElement) -> [ASLayoutElement] {
        [expression]
    }

    public static func buildExpression(_ expression: [ASLayoutElement]) -> [ASLayoutElement] {
        expression
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
