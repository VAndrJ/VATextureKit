//
//  NSMutableAttributedString+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//

import Foundation

public extension NSMutableAttributedString {

    convenience init(
        string: String,
        font: UIFont,
        color: UIColor,
        alignment: NSTextAlignment = .natural,
        secondary: [(
            strings: [String],
            font: UIFont?,
            color: UIColor,
            attributes: [NSAttributedString.Key: Any]
        )] = []
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
        ]

        self.init(string: string, attributes: attributes)

        guard !secondary.isEmpty else { return }
        
        secondary.forEach { secondary in
            let allSecondaryAttributes = [NSAttributedString.Key.foregroundColor: secondary.color]
                .merging(
                    secondary.attributes,
                    uniquingKeysWith: { $1 }
                )
                .merging(
                    secondary.font.flatMap {
                        [.font: $0]
                    } ?? [:],
                    uniquingKeysWith: { $1 }
                )
            secondary.strings.forEach {
                string.ranges(of: $0).forEach { range in
                    addAttributes(
                        allSecondaryAttributes,
                        range: NSRange(range, in: string)
                    )
                }
            }
        }
    }
}

extension String {

    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(range)
        }
        
        return ranges
    }
}
