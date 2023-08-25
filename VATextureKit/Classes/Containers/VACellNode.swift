//
//  VACellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VACellNode: ASCellNode, VACornerable {
    public var theme: VATheme { appContext.themeManager.theme }
    public var corner: VACornerRoundingParameters {
        didSet { updateCornerParameters() }
    }

    var shouldConfigureTheme = true

    public init(corner: VACornerRoundingParameters) {
        self.corner = corner

        super.init()

        automaticallyManagesSubnodes = true
        configureLayoutElements()
    }

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
