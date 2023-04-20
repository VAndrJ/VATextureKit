//
//  VATextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

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
    
    public var text: String? {
        didSet { configureTheme() }
    }
    public var theme: VATheme { appContext.themeManager.theme }
    
    public let stringGetter: (String?, VATheme) -> NSAttributedString?
    
    public convenience init(
        text: String? = nil,
        fontStyle: FontStyle = .body,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byTruncatingTail,
        maximumNumberOfLines: UInt? = .none,
        themeColor: @escaping (VATheme) -> UIColor
    ) {
        self.init(
            text: text,
            fontStyle: fontStyle,
            alignment: alignment,
            truncationMode: truncationMode,
            maximumNumberOfLines: maximumNumberOfLines,
            colorGetter: { themeColor(appContext.themeManager.theme) }
        )
    }
    
    public convenience init(
        text: String? = nil,
        fontStyle: FontStyle = .body,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byTruncatingTail,
        maximumNumberOfLines: UInt? = .none,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label }
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.init(
            text: text,
            stringGetter: { string, _ in
                string.flatMap {
                    NSAttributedString(
                        string: $0,
                        attributes: [
                            .font: UIFont.systemFont(
                                ofSize: fontStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                                weight: fontStyle.weight
                            ),
                            .foregroundColor: colorGetter(),
                            .paragraphStyle: paragraphStyle,
                        ]
                    )
                }
            }
        )

        self.truncationMode = truncationMode
        if let maximumNumberOfLines {
            self.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    public convenience init(
        text: String? = nil,
        fontGetter: @escaping (_ contentSize: () -> UIContentSizeCategory) -> UIFont,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byTruncatingTail,
        maximumNumberOfLines: UInt? = .none,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label }
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.init(
            text: text,
            stringGetter: { string, _ in
                string.flatMap {
                    NSAttributedString(
                        string: $0,
                        attributes: [
                            .font: fontGetter { appContext.contentSizeManager.contentSize },
                            .foregroundColor: colorGetter(),
                            .paragraphStyle: paragraphStyle,
                        ]
                    )
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
            configureTheme()
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
    
    open func configureTheme() {
        attributedText = stringGetter(text, theme)
    }
    
    open func themeDidChanged() {
        configureTheme()
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
