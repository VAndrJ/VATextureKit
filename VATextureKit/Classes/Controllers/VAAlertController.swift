//
//  VAAlertController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import UIKit

open class VAAlertController: UIAlertController, VAThemeObserver {
    open override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusBarStyle }

    /// The currently active theme obtained from the app's context.
    @inline(__always) @inlinable public var theme: VATheme { appContext.themeManager.theme }
    
    public convenience init(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actions: UIAlertAction...
    ) {
        self.init(
            title: title,
            message: message,
            preferredStyle: preferredStyle,
            actions: Array(actions)
        )
    }

    public convenience init(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction]
    ) {
        self.init(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )

        actions.forEach { addAction($0) }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(theme)
        appContext.themeManager.addThemeObserver(self)
    }
    
    @objc open func configureTheme(_ theme: VATheme) {
        overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
        setNeedsStatusBarAppearanceUpdate()
    }

    nonisolated public func themeDidChanged(to newValue: VATheme) {
        Task { @MainActor in
            configureTheme(newValue)
        }
    }

    deinit {
        appContext.themeManager.removeThemeObserver(self)
    }
}
