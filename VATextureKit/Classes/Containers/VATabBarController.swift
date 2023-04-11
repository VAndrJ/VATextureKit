//
//  VATabBarController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATabBarController: ASTabBarController {
    open override var childForStatusBarStyle: UIViewController? { selectedViewController }
    
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
        tabBar.barStyle = theme.barStyle
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme(appContext.themeManager.theme)
    }
}
