//
//  VATextNode+Support.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

extension VATextNode {
    enum FontDescriptor {
        case `default`
        case monospaced
        case monospacedDigits
    }

    struct SecondaryTextAttributes {
        let strings: [String]
        var textStyle: TextStyle = .body
        let color: (VATheme) -> UIColor
        var descriptor: FontDescriptor = .default
        var attributes: [NSAttributedString.Key: Any] = [:]
    }

    convenience init(
        string: String,
        textStyle: TextStyle = .body,
        color: @escaping (VATheme) -> UIColor,
        alignment: NSTextAlignment = .natural,
        descriptor: FontDescriptor = .default,
        lineBreakMode: NSLineBreakMode? = .byTruncatingTail,
        maximumNumberOfLines: Int? = nil,
        secondary: [SecondaryTextAttributes] = []
    ) {
        func getFont(descriptor: FontDescriptor, textStyle: TextStyle) -> UIFont {
            switch descriptor {
            case .default:
                return UIFont.systemFont(
                    ofSize: textStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                    weight: textStyle.weight
                )
            case .monospaced:
                return UIFont.monospacedSystemFont(
                    ofSize: textStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                    weight: textStyle.weight
                )
            case .monospacedDigits:
                return UIFont.monospacedDigitSystemFont(
                    ofSize: textStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                    weight: textStyle.weight
                )
            }
        }

        self.init(
            text: string,
            stringGetter: { string, theme in
                NSMutableAttributedString(
                    string: string ?? "",
                    font: getFont(descriptor: descriptor, textStyle: textStyle),
                    color: color(theme),
                    alignment: alignment,
                    lineBreakMode: lineBreakMode,
                    maximumNumberOfLines: maximumNumberOfLines,
                    secondary: secondary.map { secondary in
                        (
                            strings: secondary.strings,
                            font: getFont(descriptor: secondary.descriptor, textStyle: secondary.textStyle),
                            color: secondary.color(theme),
                            attributes: secondary.attributes
                        )
                    }
                )
            }
        )
    }
}
