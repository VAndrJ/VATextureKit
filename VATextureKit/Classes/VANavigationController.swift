//
//  VANavigationController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VANavigationController: ASDKNavigationController {
    open override var childForStatusBarStyle: UIViewController? { topViewController }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(appContext.themeManager.theme)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeDidChanged(_:)),
            name: VAContentSizeManager.contentSizeDidChangedNotification,
            object: appContext.contentSizeManager
        )
    }
    
    open func configureTheme(_ theme: VATheme) {
        navigationBar.barStyle = theme.barStyle
    }
    
    open func configureContentSize(_ contenSize: UIContentSizeCategory) {}
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme(appContext.themeManager.theme)
    }
    
    @objc private func contentSizeDidChanged(_ notification: Notification) {
        configureContentSize(appContext.contentSizeManager.contentSize)
    }
}
