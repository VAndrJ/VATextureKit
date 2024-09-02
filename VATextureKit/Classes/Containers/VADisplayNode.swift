//
//  VADisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VADisplayNode: VASimpleDisplayNode, VACornerable, VAThemeObserver, @unchecked Sendable {
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

    @MainActor
    @objc open func configureTheme(_ theme: VATheme) {}

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
