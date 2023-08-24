//
//  VAImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//

import AsyncDisplayKit

open class VAImageNode: ASImageNode {
    public var theme: VATheme { appContext.themeManager.theme }
    public var tintColorGetter: ((VATheme) -> UIColor)?
    public var backgroundColorGetter: ((VATheme) -> UIColor)?

    open override var tintColor: UIColor! {
        get { tintColorGetter?(theme) ?? .clear }
        set {
            tintColorGetter = { _ in newValue ?? .clear }
            updateTintColorIfNeeded(theme)
        }
    }
    
    var shouldConfigureTheme = true

    public init(
        image: UIImage? = nil,
        size: CGSize? = nil,
        contentMode: UIView.ContentMode? = nil,
        tintColor: ((VATheme) -> UIColor)? = nil,
        backgroundColor: ((VATheme) -> UIColor)? = nil
    ) {
        self.tintColorGetter = tintColor
        self.backgroundColorGetter = backgroundColor

        super.init()

        if let contentMode {
            self.contentMode = contentMode
        }
        if let image {
            self.image = image
        }
        if let size {
            self.style.preferredSize = size
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
#if DEBUG || targetEnvironment(simulator)
        addDebugLabel()
#endif
    }

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        if shouldConfigureTheme {
            themeDidChanged()
            shouldConfigureTheme = false
        }
    }

    open func configureTheme(_ theme: VATheme) {
        updateTintColorIfNeeded(theme)
        updateBackgroundColorIfNeeded(theme)
    }

    open func themeDidChanged() {
        if isInDisplayState {
            configureTheme(theme)
        } else {
            shouldConfigureTheme = true
        }
    }

    open func updateTintColorIfNeeded(_ theme: VATheme) {
        if let color = tintColorGetter?(theme) {
            imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            setNeedsDisplay()
        }
    }

    open func updateBackgroundColorIfNeeded(_ theme: VATheme) {
        if let color = backgroundColorGetter?(theme) {
            backgroundColor = color
        }
    }

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
