//
//  Column.swift
//  VATextureKit
//
//  Created by VAndrJ on 19.02.2023.
//

import AsyncDisplayKit

public final class Column: ASStackLayoutSpec {

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
