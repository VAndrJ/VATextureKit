//
//  VAFontStyle.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.03.2024.
//

import Foundation

public struct VAFontStyle: Sendable {
    public static let largeTitle = VAFontStyle(textStyle: .largeTitle, pointSize: 34, weight: .regular)
    public static let title1 = VAFontStyle(textStyle: .title1, pointSize: 28, weight: .regular)
    public static let title2 = VAFontStyle(textStyle: .title2, pointSize: 22, weight: .regular)
    public static let title3 = VAFontStyle(textStyle: .title3, pointSize: 20, weight: .regular)
    public static let headline = VAFontStyle(textStyle: .headline, pointSize: 17, weight: .semibold)
    public static let body = VAFontStyle(textStyle: .body, pointSize: 17, weight: .regular)
    public static let callout = VAFontStyle(textStyle: .callout, pointSize: 16, weight: .regular)
    public static let subhead = VAFontStyle(textStyle: .subheadline, pointSize: 15, weight: .regular)
    public static let footnote = VAFontStyle(textStyle: .footnote, pointSize: 13, weight: .regular)
    public static let caption1 = VAFontStyle(textStyle: .caption1, pointSize: 12, weight: .regular)
    public static let caption2 = VAFontStyle(textStyle: .caption2, pointSize: 11, weight: .regular)

    public let textStyle: UIFont.TextStyle
    public let pointSize: CGFloat
    public let weight: UIFont.Weight

    public init(
        textStyle: UIFont.TextStyle = .body,
        pointSize: CGFloat,
        weight: UIFont.Weight
    ) {
        self.textStyle = textStyle
        self.pointSize = pointSize
        self.weight = weight
    }

    public func getFontSize(contentSize: UIContentSizeCategory) -> CGFloat {
        UIFontMetrics(forTextStyle: textStyle)
            .scaledValue(
                for: pointSize,
                compatibleWith: UITraitCollection(preferredContentSizeCategory: contentSize)
            )
    }
}
