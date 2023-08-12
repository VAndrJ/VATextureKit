//
//  VAAlertController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import UIKit

open class VAAlertController: UIAlertController {
    open override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusBarStyle }

    public var theme: VATheme { appContext.themeManager.theme }
    
    public convenience init(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actions: UIAlertAction...
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle, actions: Array(actions))
    }

    public convenience init(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction]
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)

        actions.forEach(addAction(_:))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        themeDidChanged()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
    }
    
    open func configureTheme(_ theme: VATheme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open func themeDidChanged() {
        configureTheme(theme)
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
