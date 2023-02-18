//
//  VATabBarController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATabBarController<Theme>: ASTabBarController {
    open override var childForStatusBarStyle: UIViewController? { selectedViewController }
    public let themeManager: VAThemeManager<Theme>
    
    public init(themeManager: VAThemeManager<Theme>) {
        self.themeManager = themeManager
        
        super.init()
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
        tabBar.barStyle = (themeManager.theme as! VATheme).barStyle
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme()
    }
}
