//
//  VATextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATextNode: ASTextNode {
    // TODO: - All https://developer.apple.com/design/human-interface-guidelines/foundations/typography/
    public enum TextStyle {
        case headline
        case body
        case footnote
        case custom(fontSize: CGFloat, weight: UIFont.Weight)
        
        var fontSize: CGFloat {
            switch self {
            case .headline: return 17
            case .body: return 17
            case .footnote: return 13
            case .custom(let fontSize, _): return fontSize
            }
        }
        var weight: UIFont.Weight {
            switch self {
            case .headline: return .semibold
            case .body: return .regular
            case .footnote: return .regular
            case .custom(_, let weight): return weight
            }
        }
    }
    
    public var text: String? {
        didSet { configureTheme() }
    }
    
    public let textStyle: TextStyle
    public let colorGetter: () -> UIColor
    
    public convenience init(
        text: String? = nil,
        textStyle: TextStyle = .body,
        themeColor: @escaping (VATheme) -> UIColor
    ) {
        self.init(text: text, textStyle: textStyle, colorGetter: { themeColor(theme) })
    }
    
    public init(
        text: String? = nil,
        textStyle: TextStyle = .body,
        colorGetter: @escaping () -> UIColor = { theme.label }
    ) {
        self.textStyle = textStyle
        self.colorGetter = colorGetter
        
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
    }
    
    open func configureTheme() {
        attributedText = text.flatMap {
            NSAttributedString(
                string: $0,
                attributes: [
                    .font: UIFont.systemFont(
                        ofSize: textStyle.fontSize,
                        weight: textStyle.weight
                    ),
                    .foregroundColor: colorGetter(),
                ]
            )
        }
    }
    
    open func themeDidChanged() {
        configureTheme()
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
