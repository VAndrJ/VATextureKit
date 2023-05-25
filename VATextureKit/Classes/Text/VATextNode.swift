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

open class VATextNode: ASTextNode2 {
    public struct FontStyle {
        public static let largeTitle = FontStyle(textStyle: .largeTitle, pointSize: 34, weight: .regular)
        public static let title1 = FontStyle(textStyle: .title1, pointSize: 28, weight: .regular)
        public static let title2 = FontStyle(textStyle: .title2, pointSize: 22, weight: .regular)
        public static let title3 = FontStyle(textStyle: .title3, pointSize: 20, weight: .regular)
        public static let headline = FontStyle(textStyle: .headline, pointSize: 17, weight: .semibold)
        public static let body = FontStyle(textStyle: .body, pointSize: 17, weight: .regular)
        public static let callout = FontStyle(textStyle: .callout, pointSize: 16, weight: .regular)
        public static let subhead = FontStyle(textStyle: .subheadline, pointSize: 15, weight: .regular)
        public static let footnote = FontStyle(textStyle: .footnote, pointSize: 13, weight: .regular)
        public static let caption1 = FontStyle(textStyle: .caption1, pointSize: 12, weight: .regular)
        public static let caption2 = FontStyle(textStyle: .caption2, pointSize: 11, weight: .regular)

        public let textStyle: UIFont.TextStyle
        public let pointSize: CGFloat
        public let weight: UIFont.Weight

        public init(textStyle: UIFont.TextStyle = .body, pointSize: CGFloat, weight: UIFont.Weight) {
            self.textStyle = textStyle
            self.pointSize = pointSize
            self.weight = weight
        }
        
        public func getFontSize(contentSize: UIContentSizeCategory) -> CGFloat {
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSize)
            return UIFontMetrics(forTextStyle: textStyle).scaledValue(for: pointSize, compatibleWith: traitCollection)
        }
    }

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
        didSet { configureTheme(theme: theme) }
    }
    public var theme: VATheme { appContext.themeManager.theme }
    
    public let stringGetter: (String?, VATheme) -> NSAttributedString?
    
    public convenience init(
        text: String? = nil,
        fontStyle: FontStyle = .body,
        kern: VAKern? = nil,
        lineHeight: VALineHeight? = nil,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byTruncatingTail,
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
        truncationMode: NSLineBreakMode = .byTruncatingTail,
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
            configureTheme(theme: theme)
        }
    }
    
    open override func didLoad() {
        super.didLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAContentSizeManager.contentSizeDidChangedNotification,
            object: appContext.contentSizeManager
        )
    }
    
    open func configureTheme(theme: VATheme) {
        attributedText = stringGetter(text, theme)
    }
    
    open func themeDidChanged() {
        configureTheme(theme: theme)
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
