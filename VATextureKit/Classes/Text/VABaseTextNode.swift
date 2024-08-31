//
//  VABaseTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

public import AsyncDisplayKit

#if AS_ENABLE_TEXTNODE2
open class _VATextNode: ASTextNode2 {}
#else
open class _VATextNode: ASTextNode {}
#endif

open class VABaseTextNode: _VATextNode, VAThemeObserver, VAContentSizeObserver {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    private(set) var shouldConfigureTheme = true
    private(set) var isObservingChanges = false

    @MainActor
    open override func didLoad() {
        super.didLoad()

        if overrides(#selector(configureTheme(_:))) {
            appContext.themeManager.addThemeObserver(self)
            appContext.contentSizeManager.addContentSizeObserver(self)
            isObservingChanges = true
        }
    }

    @MainActor
    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        if shouldConfigureTheme {
            configureTheme(theme)
            shouldConfigureTheme = false
        }
    }

    @objc open func configureTheme(_ theme: VATheme) {}

    public func themeDidChanged(to newTheme: VATheme) {
        if isInDisplayState {
            configureTheme(newTheme)
        } else {
            shouldConfigureTheme = true
        }
    }

    public func contentSizeDidChanged(to newValue: UIContentSizeCategory) {
        if isInDisplayState {
            configureTheme(theme)
        } else {
            shouldConfigureTheme = true
        }
    }

    deinit {
        if isObservingChanges {
            appContext.themeManager.removeThemeObserver(self)
            appContext.contentSizeManager.removeContentSizeObserver(self)
        }
    }
}
