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
        didSet { updateCornerParameters() }
    }

    var shouldConfigureTheme = true

    /// Initializes a `VACellNode` instance with the specified corner rounding parameters.
    ///
    /// - Parameter corner: The corner rounding parameters to apply to the cell.
    public init(corner: VACornerRoundingParameters) {
        self.corner = corner

        super.init()

        automaticallyManagesSubnodes = true
        configureLayoutElements()
    }

    /// Initializes a `VACellNode` instance with default corner rounding parameters.
    public override init() {
        self.corner = .init()

        super.init()
        
        automaticallyManagesSubnodes = true
        configureLayoutElements()
    }
    
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

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        if shouldConfigureTheme {
            themeDidChanged()
            shouldConfigureTheme = false
        }
    }

    open override func layout() {
        super.layout()

        updateCornerProportionalIfNeeded()
    }

    /// Method for layout parameters that need to be defined only once
    /// and are used throughout the layout calculations within the `layoutSpecThatFits`.
    open func configureLayoutElements() {}
    
    /// Configure the appearance of the cell based on the provided theme.
    open func configureTheme(_ theme: VATheme) {}
    
    /// Called when the theme changes. Configures the theme if the cell is in the display state, otherwise sets the `shouldConfigureTheme` flag.
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
