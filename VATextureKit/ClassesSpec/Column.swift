//
//  Column.swift
//  VATextureKitSpec
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

/// The `Column` class is a wrapper around `ASStackLayoutSpec` for `vertical` direction.
public final class Column: ASStackLayoutSpec {

    /// Wrapper init, creates a new `Column`
    ///
    /// - Parameters:
    ///   - spacing: The spacing (in points) to apply between the child elements in the vertical stack. Defaults to `0`
    ///   - main: The alignment of the child elements along the main axis (vertical axis). Defaults to `.start`
    ///   - cross: The alignment of the child elements along the cross axis (horizontal axis). Defaults to `.start`
    ///   - wrap: The flex wrap mode for child elements when they exceed the height of the container. Defaults to `.noWrap`
    ///   - alignContent: The alignment of the lines when there is extra space along the cross axis. Defaults to `.start`
    ///   - line: The spacing (in points) between the lines of child elements in the vertical stack. Defaults to `0`
    ///   - content: A result builder closure that returns an array of `ASLayoutElement` objects, representing the child elements to be included in the horizontal stack.
    public convenience init(
        spacing: CGFloat = 0,
        main: ASStackLayoutJustifyContent = .start,
        cross: ASStackLayoutAlignItems = .start,
        wrap: ASStackLayoutFlexWrap = .noWrap,
        alignContent: ASStackLayoutAlignContent = .start,
        line: CGFloat = 0,
        @LayoutSpecBuilder content: () -> [any ASLayoutElement]
    ) {
        self.init(
            direction: .vertical,
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
