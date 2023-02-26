//
//  VADisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VADisplayNode: ASDisplayNode {
    
    public override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    open override func didLoad() {
        super.didLoad()
        
        configureTheme(appContext.themeManager.theme)
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
    
    open func configureTheme(_ theme: VATheme) {}
    
    open func themeDidChanged() {
        configureTheme(appContext.themeManager.theme)
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
