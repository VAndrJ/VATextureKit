//
//  VAWindow.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAWindow: UIWindow {
    
    public init(themeManager: VAThemeManager) {
        super.init(frame: UIScreen.main.bounds)
        
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
        appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: traitCollection.userInterfaceStyle)
    }
    
    @available(iOS 13.0, *)
    public init(themeManager: VAThemeManager, windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
        appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: traitCollection.userInterfaceStyle)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: traitCollection.userInterfaceStyle)
        }
    }
    
    deinit {
        appContexts.removeAll(where: { $0.window === self })
    }
}
