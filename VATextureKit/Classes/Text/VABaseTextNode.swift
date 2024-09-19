//
//  VABaseTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VABaseTextNode: VASimpleTextNode, VAThemeObserver, VAContentSizeObserver, @unchecked Sendable {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    private(set) var shouldConfigureTheme = true
    private(set) var isObservingChanges = false

    open override func viewDidLoad() {
        super.viewDidLoad()

        if overrides(#selector(configureTheme(_:))) {
            appContext.themeManager.addThemeObserver(self)
            appContext.contentSizeManager.addContentSizeObserver(self)
            isObservingChanges = true
        }
    }

    open override func viewDidEnterDisplayState() {
        super.viewDidEnterDisplayState()

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
