//
//  VATextNode+Support.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

extension VATextNode {
    struct SecondaryTextAttributes {
        let strings: [String]
        var textStyle: VAFontStyle = .body
        let color: (VATheme) -> UIColor
        var descriptor: VAFontDesign = .default
        var attributes: [NSAttributedString.Key: Any] = [:]
    }

    // swiftlint:disable:next function_body_length
    convenience init(
        string: String,
        textStyle: VAFontStyle = .body,
        color: @escaping (VATheme) -> UIColor,
        alignment: NSTextAlignment = .natural,
        descriptor: VAFontDesign = .default,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt? = nil,
        secondary: [SecondaryTextAttributes] = []
    ) {
        func getFont(descriptor: VAFontDesign, textStyle: VAFontStyle) -> UIFont {
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
            case .italic:
                return UIFont.italicSystemFont(
                    ofSize: textStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize)
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
                    secondary: secondary.map { secondary in
                        return (
                            strings: secondary.strings,
                            font: getFont(descriptor: secondary.descriptor, textStyle: secondary.textStyle),
                            color: secondary.color(theme),
                            attributes: secondary.attributes
                        )
                    }
                )
            }
        )

        self.truncationMode = truncationMode
        if let maximumNumberOfLines {
            self.maximumNumberOfLines = maximumNumberOfLines
        }
    }
}

func getTitleTextNode(string: String, selection: String) -> VATextNode {
    let fontDesign: VAFontDesign = .monospaced

    return VATextNode(
        string: string,
        color: { $0.label },
        descriptor: fontDesign,
        secondary: [
            .init(strings: [selection], color: { $0.systemIndigo }, descriptor: fontDesign),
        ]
    )
}
