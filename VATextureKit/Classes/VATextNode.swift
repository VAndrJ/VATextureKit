//
//  VATextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATextNode: ASTextNode {
    public enum TextStyle {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case body
        case callout
        case subhead
        case footnote
        case caption1
        case caption2
        
        func getFontSize(contentSize: UIContentSizeCategory) -> CGFloat {
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSize)
            switch self {
            case .largeTitle: return UIFontMetrics(forTextStyle: .largeTitle).scaledValue(for: 34, compatibleWith: traitCollection)
            case .title1: return UIFontMetrics(forTextStyle: .title1).scaledValue(for: 28, compatibleWith: traitCollection)
            case .title2: return UIFontMetrics(forTextStyle: .title2).scaledValue(for: 22, compatibleWith: traitCollection)
            case .title3: return UIFontMetrics(forTextStyle: .title3).scaledValue(for: 20, compatibleWith: traitCollection)
            case .headline: return UIFontMetrics(forTextStyle: .headline).scaledValue(for: 17, compatibleWith: traitCollection)
            case .body: return UIFontMetrics(forTextStyle: .body).scaledValue(for: 17, compatibleWith: traitCollection)
            case .callout: return UIFontMetrics(forTextStyle: .callout).scaledValue(for: 16, compatibleWith: traitCollection)
            case .subhead: return UIFontMetrics(forTextStyle: .subheadline).scaledValue(for: 15, compatibleWith: traitCollection)
            case .footnote: return UIFontMetrics(forTextStyle: .footnote).scaledValue(for: 13, compatibleWith: traitCollection)
            case .caption1: return UIFontMetrics(forTextStyle: .caption1).scaledValue(for: 12, compatibleWith: traitCollection)
            case .caption2: return UIFontMetrics(forTextStyle: .caption2).scaledValue(for: 11, compatibleWith: traitCollection)
            }
        }
        var weight: UIFont.Weight {
            switch self {
            case .largeTitle: return .regular
            case .title1: return .regular
            case .title2: return .regular
            case .title3: return .regular
            case .headline: return .semibold
            case .body: return .regular
            case .callout: return .regular
            case .subhead: return .regular
            case .footnote: return .regular
            case .caption1: return .regular
            case .caption2: return .regular
            }
        }
    }
    
    public var text: String? {
        didSet { configureTheme() }
    }
    
    public let stringGetter: (String?) -> NSAttributedString?
    
    public convenience init(
        text: String? = nil,
        textStyle: TextStyle = .body,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode? = nil,
        maximumNumberOfLines: UInt? = nil,
        themeColor: @escaping (VATheme) -> UIColor
    ) {
        self.init(
            text: text,
            textStyle: textStyle,
            alignment: alignment,
            lineBreakMode: lineBreakMode,
            maximumNumberOfLines: maximumNumberOfLines,
            colorGetter: { themeColor(appContext.themeManager.theme) }
        )
    }
    
    public convenience init(
        text: String? = nil,
        textStyle: TextStyle = .body,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode? = nil,
        maximumNumberOfLines: UInt? = nil,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label }
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        if let lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        self.init(
            text: text,
            stringGetter: {
                $0.flatMap {
                    NSAttributedString(
                        string: $0,
                        attributes: [
                            .font: UIFont.systemFont(
                                ofSize: textStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                                weight: textStyle.weight
                            ),
                            .foregroundColor: colorGetter(),
                            .paragraphStyle: paragraphStyle,
                        ]
                    )
                }
            }
        )
        
        if let maximumNumberOfLines {
            self.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    public convenience init(
        text: String? = nil,
        fontGetter: @escaping (_ contentSize: () -> UIContentSizeCategory) -> UIFont,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode? = nil,
        maximumNumberOfLines: UInt? = nil,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label }
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        if let lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        self.init(
            text: text,
            stringGetter: {
                $0.flatMap {
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
        
        if let maximumNumberOfLines {
            self.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    public init(
        text: String?,
        stringGetter: @escaping (String?) -> NSAttributedString?
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
        attributedText = stringGetter(text)
    }
    
    open func themeDidChanged() {
        configureTheme()
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
