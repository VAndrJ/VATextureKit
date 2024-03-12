//
//  VATextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

public enum VAFontDesign: Hashable {
    case `default`
    @available (iOS 13.0, *)
    case monospaced
    case monospacedDigits
    case italic
}

public enum VAKern {
    case fixed(_ point: CGFloat)
    case relative(_ percent: CGFloat)
    case custom(_ kernGetter: (_ pointSize: CGFloat) -> CGFloat)
}

public enum VALineHeight {
    case fixed(_ height: CGFloat)
    case proportional(_ percent: CGFloat)
    case custom(_ heightGetter: (_ pointSize: CGFloat) -> CGFloat)
}

open class VATextNode: VABaseTextNode {
    public struct SecondaryAttributes {
        let strings: [String]
        let fontGetter: ((_ contentSize: UIContentSizeCategory, _ theme: VATheme) -> UIFont)?
        let kern: VAKern?
        let colorGetter: (VATheme) -> UIColor
        let attributes: [NSAttributedString.Key: Any]?

        public init(
            strings: [String],
            fontGetter: ((UIContentSizeCategory, VATheme) -> UIFont)? = nil,
            kern: VAKern? = nil,
            colorGetter: @escaping (VATheme) -> UIColor,
            attributes: [NSAttributedString.Key : Any]? = nil
        ) {
            self.strings = strings
            self.fontGetter = fontGetter
            self.kern = kern
            self.colorGetter = colorGetter
            self.attributes = attributes
        }
    }
    
    public var text: String? {
        didSet { configureTheme(theme) }
    }
    /// The currently active theme obtained from the app's context.
    public let stringGetter: (String?, VATheme) -> NSAttributedString?
    
    public convenience init(
        text: String? = nil,
        fontStyle: VAFontStyle = .body,
        kern: VAKern? = nil,
        lineHeight: VALineHeight? = nil,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt? = .none,
        colorGetter: @escaping (VATheme) -> UIColor = { $0.label },
        secondary: [SecondaryAttributes]? = nil
    ) {
        self.init(
            text: text,
            fontGetter: { contentSize, theme in
                theme.font(.design(
                    .default,
                    size: fontStyle.getFontSize(contentSize: contentSize),
                    weight: fontStyle.weight
                ))
            },
            kern: kern,
            lineHeight: lineHeight,
            alignment: alignment,
            truncationMode: truncationMode,
            maximumNumberOfLines: maximumNumberOfLines,
            colorGetter: colorGetter,
            secondary: secondary
        )
    }
    
    public convenience init(
        text: String? = nil,
        fontGetter: @escaping (_ contentSize: UIContentSizeCategory, _ theme: VATheme) -> UIFont,
        kern: VAKern? = nil,
        lineHeight: VALineHeight? = nil,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt? = .none,
        colorGetter: @escaping (VATheme) -> UIColor = { $0.label },
        secondary: [SecondaryAttributes]? = nil
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.init(
            text: text,
            stringGetter: { string, _ in
                string.flatMap { text in
                    let font = fontGetter(
                        appContext.contentSizeManager.contentSize,
                        appContext.themeManager.theme
                    )
                    if let lineHeight {
                        let customLineHeight: CGFloat
                        switch lineHeight {
                        case let .fixed(height): customLineHeight = height
                        case let .proportional(percent): customLineHeight = font.pointSize * percent / 100
                        case let .custom(heightGetter): customLineHeight = heightGetter(font.pointSize)
                        }
                        paragraphStyle.minimumLineHeight = customLineHeight
                        paragraphStyle.maximumLineHeight = customLineHeight
                        paragraphStyle.lineHeightMultiple = customLineHeight / font.pointSize
                    }
                    var attributes: [NSAttributedString.Key: Any] = [
                        .font: font,
                        .foregroundColor: colorGetter(appContext.themeManager.theme),
                        .paragraphStyle: paragraphStyle,
                    ]
                    if let kern {
                        let kernPoint: CGFloat
                        switch kern {
                        case let .fixed(point): kernPoint = point
                        case let .relative(percent): kernPoint = font.pointSize * percent / 100
                        case let .custom(kernGetter): kernPoint = kernGetter(font.pointSize)
                        }
                        attributes[.kern] = kernPoint
                    }
                    let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

                    if let secondary {
                        secondary.forEach { secondaryStringWithAttributes in
                            var secondaryAttributes: [NSAttributedString.Key: Any] = [
                                .foregroundColor: secondaryStringWithAttributes.colorGetter(appContext.themeManager.theme),
                            ]
                            if let font = secondaryStringWithAttributes.fontGetter?(
                                appContext.contentSizeManager.contentSize,
                                appContext.themeManager.theme
                            ) {
                                secondaryAttributes[.font] = font
                            }
                            if let kern = secondaryStringWithAttributes.kern {
                                let kernPoint: CGFloat
                                switch kern {
                                case let .fixed(point): kernPoint = point
                                case let .relative(percent): kernPoint = font.pointSize * percent / 100
                                case let .custom(kernGetter): kernPoint = kernGetter(font.pointSize)
                                }
                                secondaryAttributes[.kern] = kernPoint
                            }
                            if let additionalAttributes = secondaryStringWithAttributes.attributes {
                                secondaryAttributes.merge(additionalAttributes, uniquingKeysWith: { $1 })
                            }
                            secondaryStringWithAttributes.strings.forEach { string in
                                text.ranges(of: string).forEach { range in
                                    attributedString.addAttributes(
                                        secondaryAttributes,
                                        range: NSRange(range, in: text)
                                    )
                                }
                            }
                        }
                    }

                    return attributedString
                }
            }
        )

        self.truncationMode = truncationMode
        if let maximumNumberOfLines {
            self.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    public init(
        text: String?,
        stringGetter: @escaping (String?, VATheme) -> NSAttributedString?
    ) {
        self.stringGetter = stringGetter
        
        super.init()

        if let text {
            self.text = text
            configureTheme(theme)
        }
    }
    
    open override func configureTheme(_ theme: VATheme) {
        attributedText = stringGetter(text, theme)
    }
}
