//
//  VAImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//

import AsyncDisplayKit

open class VAImageNode: ASImageNode {
    public struct DTO {
        var image: UIImage?
        var tintColor: ((VATheme) -> UIColor)?
        var size: CGSize?
        var contentMode: UIView.ContentMode?
        var backgroundColor: ((VATheme) -> UIColor)?

        public init(
            image: UIImage? = nil,
            tintColor: ((VATheme) -> UIColor)? = nil,
            size: CGSize? = nil,
            contentMode: UIView.ContentMode? = nil,
            backgroundColor: ((VATheme) -> UIColor)? = nil
        ) {
            self.image = image
            self.tintColor = tintColor
            self.size = size
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
        }
    }

    public var theme: VATheme { appContext.themeManager.theme }
    open override var tintColor: UIColor! {
        get { data.tintColor?(theme) ?? .clear }
        set {
            data.tintColor = { _ in newValue ?? .clear }
            updateTintColorIfNeeded(theme)
        }
    }

    private var data: DTO

    public init(data: DTO) {
        self.data = data

        super.init()

        if let contentMode = data.contentMode {
            self.contentMode = contentMode
        }
        if let image = data.image {
            self.image = image
        }
        if let size = data.size {
            self.style.preferredSize = size
        }
    }

    open override func didLoad() {
        super.didLoad()

        configureTheme(theme)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
    }

    open func configureTheme(_ theme: VATheme) {
        updateTintColorIfNeeded(theme)
        updateBackgroundColorIfNeeded(theme)
    }

    open func themeDidChanged() {
        configureTheme(appContext.themeManager.theme)
    }

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }

    private func updateTintColorIfNeeded(_ theme: VATheme) {
        if let color = data.tintColor?(theme) {
            imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            setNeedsDisplay()
        }
    }

    private func updateBackgroundColorIfNeeded(_ theme: VATheme) {
        if let color = data.backgroundColor?(theme) {
            backgroundColor = color
        }
    }
}
