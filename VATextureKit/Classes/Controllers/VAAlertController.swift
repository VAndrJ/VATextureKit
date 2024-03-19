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
    public var theme: VATheme { appContext.themeManager.theme }
    
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

        actions.forEach(addAction(_:))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(theme)
        appContext.themeManager.addThemeObserver(self)
    }
    
    @objc open func configureTheme(_ theme: VATheme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    public func themeDidChanged(to newValue: VATheme) {
        configureTheme(newValue)
    }

    deinit {
        appContext.themeManager.removeThemeObserver(self)
    }
}
