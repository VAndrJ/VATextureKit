//
//  VABaseTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

public import AsyncDisplayKit

#if AS_ENABLE_TEXTNODE2
open class _VATextNode: ASTextNode2, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidload()
        }
    }

    @MainActor
    open func viewDidload() {}

    open override func layout() {
        super.layout()

        MainActor.assumeIsolated {
            layoutSubviews()
        }
    }

    @MainActor
    open func layoutSubviews() {}

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        MainActor.assumeIsolated {
            viewDidEnterDisplayState()
        }
    }

    @MainActor
    open func viewDidEnterDisplayState() {}
}

#else
open class _VATextNode: ASTextNode, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidload()
        }
    }

    @MainActor
    open func viewDidload() {}

    open override func layout() {
        super.layout()

        MainActor.assumeIsolated {
            layoutSubviews()
        }
    }

    @MainActor
    open func layoutSubviews() {}

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        MainActor.assumeIsolated {
            viewDidEnterDisplayState()
        }
    }

    @MainActor
    open func viewDidEnterDisplayState() {}
}

#endif

open class VABaseTextNode: _VATextNode, VAThemeObserver, VAContentSizeObserver {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    private(set) var shouldConfigureTheme = true
    private(set) var isObservingChanges = false

    open override func viewDidload() {
        super.viewDidload()

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
