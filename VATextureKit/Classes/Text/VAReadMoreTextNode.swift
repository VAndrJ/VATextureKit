//
//  VAReadMoreTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 20.04.2023.
//

import AsyncDisplayKit

open class VAReadMoreTextNode: VATextNode {
    public struct ReadMore {
        let truncationText: String
        let text: String
        let fontStyle: FontStyle
        let colorGetter: (VATheme) -> UIColor

        public init(
            truncationText: String = "…",
            text: String,
            fontStyle: VATextNode.FontStyle,
            colorGetter: @escaping (VATheme) -> UIColor
        ) {
            self.truncationText = truncationText
            self.text = text
            self.fontStyle = fontStyle
            self.colorGetter = colorGetter
        }
    }

    public private(set) var readMore: ReadMore?
    public weak var textDelegate: ASTextNodeDelegate?
    public private(set) lazy var readMoreStringGetter: ((ReadMore) -> NSAttributedString?)? = { [weak self] in
        guard let self else {
            return nil
        }
        return NSAttributedString(
            string: $0.text,
            attributes: [
                .font: UIFont.systemFont(
                    ofSize: $0.fontStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                    weight: $0.fontStyle.weight
                ),
                .foregroundColor: $0.colorGetter(self.theme)
            ]
        )
    }

    public convenience init(
        text: String? = nil,
        fontStyle: FontStyle = .body,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byTruncatingTail,
        maximumNumberOfLines: UInt,
        themeColor: @escaping (VATheme) -> UIColor,
        readMore: ReadMore
    ) {
        self.init(
            text: text,
            fontStyle: fontStyle,
            alignment: alignment,
            truncationMode: truncationMode,
            maximumNumberOfLines: maximumNumberOfLines,
            themeColor: themeColor
        )

        self.readMore = readMore
        truncationAttributedText = NSAttributedString(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter?(readMore)
    }

    public convenience init(
        text: String? = nil,
        fontGetter: @escaping (_ contentSize: () -> UIContentSizeCategory) -> UIFont,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label },
        readMore: ReadMore
    ) {
        self.init(
            text: text,
            fontGetter: fontGetter,
            alignment: alignment,
            truncationMode: truncationMode,
            maximumNumberOfLines: maximumNumberOfLines,
            colorGetter: colorGetter
        )

        self.readMore = readMore
        truncationAttributedText = NSAttributedString(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter?(readMore)
    }

    public convenience init(
        text: String? = nil,
        fontStyle: FontStyle = .body,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt,
        colorGetter: @escaping () -> UIColor = { appContext.themeManager.theme.label },
        readMore: ReadMore
    ) {
        self.init(
            text: text,
            fontStyle: fontStyle,
            alignment: alignment,
            truncationMode: truncationMode,
            maximumNumberOfLines: maximumNumberOfLines,
            colorGetter: colorGetter
        )

        self.readMore = readMore
        truncationAttributedText = NSAttributedString(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter?(readMore)
    }

    public convenience init(
        text: String?,
        stringGetter: @escaping (String?, VATheme) -> NSAttributedString?,
        readMore: ReadMore,
        readMoreStringGetter: @escaping (ReadMore) -> NSAttributedString?
    ) {
        self.init(text: text, stringGetter: stringGetter)

        self.readMore = readMore
        self.readMoreStringGetter = readMoreStringGetter
        truncationAttributedText = NSAttributedString(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter(readMore)
    }

    open override func didLoad() {
        super.didLoad()

        isUserInteractionEnabled = true
        delegate = self
    }

    open override func configureTheme() {
        additionalTruncationMessage = readMore.flatMap { readMoreStringGetter?($0) }

        super.configureTheme()
    }
}

// MARK: - ASTextNodeDelegate

extension VAReadMoreTextNode: ASTextNodeDelegate {

    public func textNode(_ textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
        textDelegate?.textNode?(textNode, shouldHighlightLinkAttribute: attribute, value: value, at: point) ?? false
    }

    public func textNode(_ textNode: ASTextNode!, shouldLongPressLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
        textDelegate?.textNode?(textNode, shouldLongPressLinkAttribute: attribute, value: value, at: point) ?? false
    }

    public func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        textDelegate?.textNode?(textNode, tappedLinkAttribute: attribute, value: value, at: point, textRange: textRange)
    }

    public func textNode(_ textNode: ASTextNode!, longPressedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        textDelegate?.textNode?(textNode, longPressedLinkAttribute: attribute, value: value, at: point, textRange: textRange)
    }

    public func textNodeTappedTruncationToken(_ textNode: ASTextNode!) {
        maximumNumberOfLines = 0
        setNeedsLayout()
        textDelegate?.textNodeTappedTruncationToken?(textNode)
    }
}