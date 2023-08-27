//
//  Row.swift
//  VATextureKitSpec
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// The `Row` class is a wrapper around `ASStackLayoutSpec` for `horizontal` direction.
public final class Row: ASStackLayoutSpec {

    /// Wrapper init, creates a new `Row`
    ///
    /// - Parameters:
    ///   - spacing: The spacing (in points) to apply between the child elements in the horizontal stack. Defaults to `0`
    ///   - main: The alignment of the child elements along the main axis (horizontal axis). Defaults to `.start`
    ///   - cross: The alignment of the child elements along the cross axis (vertical axis). Defaults to `.start`
    ///   - wrap: The flex wrap mode for child elements when they exceed the width of the container. Defaults to `.noWrap`
    ///   - alignContent: The alignment of the lines when there is extra space along the cross axis. Defaults to `.start`
    ///   - line: The spacing (in points) between the lines of child elements in the horizontal stack. Defaults to `0`
    ///   - content: A rewult builder closure that returns an array of `ASLayoutElement` objects, representing the child elements to be included in the horizontal stack.
    public convenience init(
        spacing: CGFloat = 0,
        main: ASStackLayoutJustifyContent = .start,
        cross: ASStackLayoutAlignItems = .start,
        wrap: ASStackLayoutFlexWrap = .noWrap,
        alignContent: ASStackLayoutAlignContent = .start,
        line: CGFloat = 0,
        @LayoutSpecBuilder content: () -> [ASLayoutElement]
    ) {
        self.init(
            direction: .horizontal,
            spacing: spacing,
            justifyContent: main,
            alignItems: cross,
            flexWrap: wrap,
            alignContent: alignContent,
            lineSpacing: line,
            children: content()
        )
    }
}
