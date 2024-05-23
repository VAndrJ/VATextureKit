//
//  VAWindow.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAWindow: UIWindow {

    @available(iOS 12.0, *)
    public init(
        customTheme: VATheme,
        standardLightTheme: VATheme,
        standardDarkTheme: VATheme
    ) {
        super.init(frame: UIScreen.main.bounds)
        
        let themeManager = VAThemeManager(
            customTheme: customTheme,
            standardLightTheme: standardLightTheme,
            standardDarkTheme: standardDarkTheme,
            userInterfaceStyle: VAUserInterfaceStyle(userInterfaceStyle: traitCollection.userInterfaceStyle)
        )
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
    }

    public init(
        customTheme: VATheme,
        legacyLightTheme: VATheme,
        legacyDarkTheme: VATheme
    ) {
        super.init(frame: UIScreen.main.bounds)

        let themeManager = VAThemeManager(
            customTheme: customTheme,
            standardLightTheme: legacyLightTheme,
            standardDarkTheme: legacyDarkTheme,
            userInterfaceStyle: .light
        )
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
    }

    @available(iOS 12.0, *)
    public convenience init(standardLightTheme: VATheme) {
        self.init(
            standardLightTheme: standardLightTheme,
            standardDarkTheme: standardLightTheme
        )
    }

    public convenience init(legacyLightTheme: VATheme) {
        self.init(
            legacyLightTheme: legacyLightTheme,
            legacyDarkTheme: legacyLightTheme
        )
    }

    @available(iOS 12.0, *)
    public init(standardLightTheme: VATheme, standardDarkTheme: VATheme) {
        super.init(frame: UIScreen.main.bounds)
        
        let themeManager = VAThemeManager(
            standardLightTheme: standardLightTheme,
            standardDarkTheme: standardDarkTheme,
            userInterfaceStyle: VAUserInterfaceStyle(userInterfaceStyle: traitCollection.userInterfaceStyle)
        )
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
    }

    public init(legacyLightTheme: VATheme, legacyDarkTheme: VATheme) {
        super.init(frame: UIScreen.main.bounds)

        let themeManager = VAThemeManager(
            standardLightTheme: legacyLightTheme,
            standardDarkTheme: legacyDarkTheme,
            userInterfaceStyle: .light
        )
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
    }

    @available(iOS 12.0, *)
    public init(themeManager: VAThemeManager) {
        super.init(frame: UIScreen.main.bounds)
        
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
        appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: VAUserInterfaceStyle(userInterfaceStyle: traitCollection.userInterfaceStyle))
    }
    
    @available(iOS 13.0, *)
    public init(themeManager: VAThemeManager, windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        appContexts.append(VAAppContext(themeManager: themeManager, window: self))
        appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: VAUserInterfaceStyle(userInterfaceStyle: traitCollection.userInterfaceStyle))
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            appContext.themeManager.updateStandardThemeIfNeeded(userInterfaceStyle: VAUserInterfaceStyle(userInterfaceStyle: traitCollection.userInterfaceStyle))
        }
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            appContext.contentSizeManager.updateIfNeeded(contentSize: traitCollection.preferredContentSizeCategory)
        }
    }
    
    deinit {
        appContexts.removeAll(where: { $0.window === self })
    }
}
