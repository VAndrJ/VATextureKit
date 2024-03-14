//
//  ThemeManager.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ThemeManager: @unchecked Sendable {
    var currentTheme: Theme {
        let themeManager = appContext.themeManager
        switch themeManager.theme.tag {
        case _ as VALightThemeTag where themeManager.themeType == .custom:
            return .light
        case _ as VADarkThemeTag where themeManager.themeType == .custom:
            return .dark
        case _ as PurpleThemeTag:
            return .purple
        default:
            return .system
        }
    }

    @VANilableRawUserDefault(key: "com.vandrj.theme")
    private var theme: Theme?
    
    func checkInitialTheme() {
        if let theme {
            changeIfNeeded(to: theme)
        }
    }
    
    func update(theme newTheme: Theme) {
        theme = newTheme
        changeIfNeeded(to: newTheme)
    }
    
    private func changeIfNeeded(to newTheme: Theme) {
        switch newTheme {
        case .light:
            if !(appContext.themeManager.theme.tag is VALightThemeTag) || appContext.themeManager.themeType == .standard {
                appContext.themeManager.setLightAsCustomTheme()
            }
        case .dark:
            if !(appContext.themeManager.theme.tag is VADarkThemeTag) || appContext.themeManager.themeType == .standard {
                appContext.themeManager.setDarkAsCustomTheme()
            }
        case .purple:
            if !(appContext.themeManager.theme.tag is PurpleThemeTag) {
                appContext.themeManager.setCustomTheme(.purple)
            }
        case .system:
            if appContext.themeManager.themeType != .standard {
                appContext.themeManager.setStandardTheme()
            }
        }
    }
}
