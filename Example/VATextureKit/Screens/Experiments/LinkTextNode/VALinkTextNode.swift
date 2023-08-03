//
//  VALinkTextNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

open class VALinkTextNode: VATextNode {
    public var onLinkTap: ((URL) -> Void)?
    public var linkObs: Observable<URL> {
        if let linkRelay {
            return linkRelay.asObservable()
        } else {
            let linkRelay = PublishRelay<URL>()
            self.linkRelay = linkRelay
            return linkRelay.asObservable()
        }
    }

    private var linkRelay: PublishRelay<URL>?

    open override func didLoad() {
        super.didLoad()

        isUserInteractionEnabled = true
        delegate = self
    }

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        supernode?.layer.as_allowsHighlightDrawing = true
    }

    open override func configureTheme(theme: VATheme) {
        if let attributedText = stringGetter(text, theme).flatMap(NSMutableAttributedString.init(attributedString:)) {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector?.matches(
                in: attributedText.string,
                options: [],
                range: NSRange(location: 0, length: attributedText.string.utf16.count)
            )
            matches?.forEach { match in
                if let range = Range(match.range, in: attributedText.string) {
                    var attibutes: [NSAttributedString.Key: Any] = [.foregroundColor: theme.systemBlue]
                    attibutes[.link] = URL(string: String(attributedText.string[range]))
                    attributedText.addAttributes(attibutes, range: match.range)
                }
            }
            self.attributedText = attributedText
        } else {
            self.attributedText = nil
        }

        highlightStyle = theme.userInterfaceStyle == .dark ? .dark : .light
    }
}

// MARK: - ASTextNodeDelegate

extension VALinkTextNode: ASTextNodeDelegate {

    public func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        guard let url = value as? URL else { return }
        linkRelay?.accept(url)
        onLinkTap?(url)
    }
}
