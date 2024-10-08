//
//  VAReadMoreTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 20.04.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VAReadMoreTextNode: VATextNode, @unchecked Sendable {
    public struct ReadMore {
        let truncationText: String
        let text: String
        let fontStyle: VAFontStyle
        let colorGetter: (VATheme) -> UIColor

        public init(
            truncationText: String = "…",
            text: String,
            fontStyle: VAFontStyle,
            colorGetter: @escaping (VATheme) -> UIColor
        ) {
            self.truncationText = truncationText
            self.text = text
            self.fontStyle = fontStyle
            self.colorGetter = colorGetter
        }
    }

    public private(set) var readMore: ReadMore?
    public weak var textDelegate: (any ASTextNodeDelegate)?
    public private(set) lazy var readMoreStringGetter: ((ReadMore, VATheme) -> NSAttributedString?)? = { [weak self] readMore, theme in
        guard let self else {
            return nil
        }
        
        return .init(
            string: readMore.text,
            attributes: [
                .font: theme.font(.design(
                    .default,
                    size: readMore.fontStyle.getFontSize(contentSize: appContext.contentSizeManager.contentSize),
                    weight: readMore.fontStyle.weight
                )),
                .foregroundColor: readMore.colorGetter(self.theme)
            ]
        )
    }

    public convenience init(
        text: String? = nil,
        fontGetter: @escaping (_ contentSize: UIContentSizeCategory, _ theme: VATheme) -> UIFont,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt,
        colorGetter: @escaping (VATheme) -> UIColor = { $0.label },
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
        truncationAttributedText = .init(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter?(readMore, theme)
    }

    public convenience init(
        text: String? = nil,
        fontStyle: VAFontStyle = .body,
        alignment: NSTextAlignment = .natural,
        truncationMode: NSLineBreakMode = .byWordWrapping,
        maximumNumberOfLines: UInt,
        colorGetter: @escaping (VATheme) -> UIColor = { $0.label },
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
        truncationAttributedText = .init(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter?(readMore, theme)
    }

    public convenience init(
        text: String?,
        stringGetter: @escaping (String?, VATheme) -> NSAttributedString?,
        readMore: ReadMore,
        readMoreStringGetter: @escaping (ReadMore, VATheme) -> NSAttributedString?
    ) {
        self.init(text: text, stringGetter: stringGetter)

        self.readMore = readMore
        self.readMoreStringGetter = readMoreStringGetter
        truncationAttributedText = .init(string: readMore.truncationText)
        additionalTruncationMessage = readMoreStringGetter(readMore, theme)
    }

    open override func didLoad() {
        super.didLoad()

        isUserInteractionEnabled = true
        delegate = self
    }

    open override func configureTheme(_ theme: VATheme) {
        additionalTruncationMessage = readMore.flatMap { readMoreStringGetter?($0, theme) }

        super.configureTheme(theme)
    }
}

// MARK: - ASTextNodeDelegate

extension VAReadMoreTextNode: ASTextNodeDelegate {

    public func textNode(
        _ textNode: ASTextNode,
        shouldHighlightLinkAttribute attribute: String,
        value: Any,
        at point: CGPoint
    ) -> Bool {
        textDelegate?.textNode?(
            textNode,
            shouldHighlightLinkAttribute: attribute,
            value: value,
            at: point
        ) ?? false
    }

    public func textNode(
        _ textNode: ASTextNode,
        shouldLongPressLinkAttribute attribute: String,
        value: Any,
        at point: CGPoint
    ) -> Bool {
        textDelegate?.textNode?(
            textNode,
            shouldLongPressLinkAttribute: attribute,
            value: value,
            at: point
        ) ?? false
    }

    public func textNode(
        _ textNode: ASTextNode,
        tappedLinkAttribute attribute: String,
        value: Any,
        at point: CGPoint,
        textRange: NSRange
    ) {
        textDelegate?.textNode?(
            textNode,
            tappedLinkAttribute: attribute,
            value: value,
            at: point,
            textRange: textRange
        )
    }

    public func textNode(
        _ textNode: ASTextNode,
        longPressedLinkAttribute attribute: String,
        value: Any,
        at point: CGPoint,
        textRange: NSRange
    ) {
        textDelegate?.textNode?(
            textNode,
            longPressedLinkAttribute: attribute,
            value: value,
            at: point,
            textRange: textRange
        )
    }

    public func textNodeTappedTruncationToken(_ textNode: ASTextNode) {
        maximumNumberOfLines = 0
        setNeedsLayout()
        textDelegate?.textNodeTappedTruncationToken?(textNode)
    }
}
