//
//  VACellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// `VACellNode` is a subclass of `ASCellNode` that provides additional functionality for handling themes and corner rounding parameters.
open class VACellNode: VASimpleCellNode, VACornerable, VAThemeObserver, @unchecked Sendable {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
    /// The corner rounding configuration for the node.
    public var corner: VACornerRoundingParameters {
        didSet {
            guard oldValue != corner else { return }

            updateCornerParameters()
        }
    }

    private(set) var shouldConfigureTheme = true
    private(set) var isObservingThemeChanges = false

    /// Initializes a `VACellNode` instance with the specified corner rounding parameters.
    ///
    /// - Parameter corner: The corner rounding parameters to apply to the cell.
    public init(corner: VACornerRoundingParameters = .default) {
        self.corner = corner

        super.init()

        automaticallyManagesSubnodes = true
        configureLayoutElements()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        updateCornerParameters()
        if overrides(#selector(configureTheme(_:))) {
            appContext.themeManager.addThemeObserver(self)
            isObservingThemeChanges = true
        } else {
            shouldConfigureTheme = false
        }
        #if DEBUG || targetEnvironment(simulator)
        addDebugLabel()
        #endif
    }

    open override func viewDidEnterDisplayState() {
        super.viewDidEnterDisplayState()

        if shouldConfigureTheme {
            configureTheme(theme)
            shouldConfigureTheme = false
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCornerProportionalIfNeeded()
    }

    /// Method for layout parameters that need to be defined only once
    /// and are used throughout the layout calculations within the `layoutSpecThatFits`.
    open func configureLayoutElements() {}
    
    /// Configure the appearance of the cell based on the provided theme.
    @MainActor
    @objc open func configureTheme(_ theme: VATheme) {}
    
    /// Called when the theme changes. Configures the theme if the cell is in the display state, otherwise sets the `shouldConfigureTheme` flag.
    public func themeDidChanged(to newValue: VATheme) {
        if isInDisplayState {
            Task { @MainActor in
                configureTheme(newValue)
            }
        } else {
            shouldConfigureTheme = true
        }
    }

    deinit {
        if isObservingThemeChanges {
            appContext.themeManager.removeThemeObserver(self)
        }
    }
}
