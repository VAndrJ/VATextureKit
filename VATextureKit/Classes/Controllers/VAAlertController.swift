//
//  VAAlertController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import UIKit

open class VAAlertController: UIAlertController {
    open override var preferredStatusBarStyle: UIStatusBarStyle { appContext.themeManager.theme.statusBarStyle }

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
        
        configureTheme(appContext.themeManager.theme)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
    }
    
    open func configureTheme(_ theme: VATheme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme(appContext.themeManager.theme)
        setNeedsStatusBarAppearanceUpdate()
    }
}
