//
//  VADisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VADisplayNode: VABaseDisplayNode {
    
    open override func didLoad() {
        super.didLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager<Any>.themeDidChangedNotification,
            object: nil
        )
    }
    
    open func themeDidChanged() {}
    
    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }
}
