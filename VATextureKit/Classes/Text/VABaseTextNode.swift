//
//  VABaseTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

import AsyncDisplayKit

#if AS_ENABLE_TEXTNODE2
open class _VATextNode: ASTextNode2 {}
#else
open class _VATextNode: ASTextNode {}
#endif

open class VABaseTextNode: _VATextNode {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    var shouldConfigureTheme = true

    @MainActor
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

    @MainActor
    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        if shouldConfigureTheme {
            themeDidChanged()
            shouldConfigureTheme = false
        }
    }

    open func configureTheme(_ theme: VATheme) {}

    open func themeDidChanged() {
        if isInDisplayState {
            configureTheme(theme)
        } else {
            shouldConfigureTheme = true
        }
    }

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
