//
//  VANavigationController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VANavigationController<Theme>: ASDKNavigationController {
    open override var childForStatusBarStyle: UIViewController? { topViewController }
    public let themeManager: VAThemeManager<Theme>
    
    public init(themeManager: VAThemeManager<Theme>) {
        self.themeManager = themeManager
        
        super.init()
    }
    
    public init(themeManager: VAThemeManager<Theme>, rootViewController: UIViewController) {
        self.themeManager = themeManager
        
        super.init(rootViewController: rootViewController)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager<Any>.themeDidChangedNotification,
            object: nil
        )
    }
    
    open func configureTheme() {
        navigationBar.barStyle = (themeManager.theme as! VATheme).barStyle
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme()
    }
}
