//
//  LayoutSpecBuilder.swift
//  VATextureKitSpec
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

/// `LayoutSpecBuilder` is a result builder used to construct an array of `ASLayoutElement` objects for use in `Layout Spec`.
@resultBuilder
public struct LayoutSpecBuilder {

    public static func buildBlock(_ components: [any ASLayoutElement]) -> [any ASLayoutElement] {
        components
    }

    public static func buildBlock(_ components: [any ASLayoutElement]...) -> [any ASLayoutElement] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: any ASLayoutElement) -> [any ASLayoutElement] {
        [expression]
    }

    public static func buildExpression(_ expression: [any ASLayoutElement]) -> [any ASLayoutElement] {
        expression
    }

    public static func buildOptional(_ component: [any ASLayoutElement]?) -> [any ASLayoutElement] {
        component ?? []
    }

    public static func buildEither(first component: [any ASLayoutElement]) -> [any ASLayoutElement] {
        component
    }

    public static func buildEither(second component: [any ASLayoutElement]) -> [any ASLayoutElement] {
        component
    }
}
