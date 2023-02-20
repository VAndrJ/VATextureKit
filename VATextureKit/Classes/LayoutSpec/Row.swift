//
//  Row.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

public final class Row: ASStackLayoutSpec {

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
