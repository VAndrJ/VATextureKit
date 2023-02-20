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
        
        configureTheme()
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
    
    open func configureTheme() {}
    
    open func themeDidChanged() {
        configureTheme()
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
