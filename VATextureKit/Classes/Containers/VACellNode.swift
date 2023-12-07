//
//  VACellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// `VACellNode` is a subclass of `ASCellNode` that provides additional functionality for handling themes and corner rounding parameters.
open class VACellNode: ASCellNode, VACornerable {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
    /// The corner rounding configuration for the node.
    public var corner: VACornerRoundingParameters {
        didSet {
            guard oldValue != corner else { return }

            updateCornerParameters()
        }
    }

    var shouldConfigureTheme = true

    /// Initializes a `VACellNode` instance with the specified corner rounding parameters.
    ///
    /// - Parameter corner: The corner rounding parameters to apply to the cell.
    public init(corner: VACornerRoundingParameters = .default) {
        self.corner = corner

        super.init()

        automaticallyManagesSubnodes = true
        configureLayoutElements()
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        updateCornerParameters()
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

    @MainActor
    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        if shouldConfigureTheme {
            themeDidChanged()
            shouldConfigureTheme = false
        }
    }

    @MainActor
    open override func layout() {
        super.layout()

        updateCornerProportionalIfNeeded()
    }

    /// Method for layout parameters that need to be defined only once
    /// and are used throughout the layout calculations within the `layoutSpecThatFits`.
    open func configureLayoutElements() {}
    
    /// Configure the appearance of the cell based on the provided theme.
    @MainActor
    open func configureTheme(_ theme: VATheme) {}
    
    /// Called when the theme changes. Configures the theme if the cell is in the display state, otherwise sets the `shouldConfigureTheme` flag.
    @MainActor
    open func themeDidChanged() {
        if isInDisplayState {
            configureTheme(theme)
        } else {
            shouldConfigureTheme = true
        }
    }

    @MainActor
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
