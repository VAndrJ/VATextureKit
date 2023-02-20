//
//  ThemeManager.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import VATextureKit

class ThemeManager {
    static let shared = ThemeManager()
    
    var currentTheme: Theme {
        switch appContext.themeManager.theme.tag {
        case _ as VALightThemeTag where appContext.themeManager.themeType == .custom:
            return .light
        case _ as VADarkThemeTag where appContext.themeManager.themeType == .custom:
            return .dark
        case _ as VioletThemeTag:
            return .violet
        default:
            return .system
        }
    }
    
    private let defaultsKey = "com.vandrj.theme"
    
    func checkInitialTheme() {
        if let theme = Theme(rawValue: UserDefaults.standard.integer(forKey: defaultsKey)) {
            change(to: theme)
        }
    }
    
    func update(theme: Theme) {
        change(to: theme)
        UserDefaults.standard.set(theme.rawValue, forKey: defaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    private func change(to theme: Theme) {
        switch theme {
        case .light:
            if !(appContext.themeManager.theme.tag is VALightThemeTag) || appContext.themeManager.themeType == .standard {
                appContext.themeManager.setLightAsCustomTheme()
            }
        case .dark:
            if !(appContext.themeManager.theme.tag is VADarkThemeTag) || appContext.themeManager.themeType == .standard {
                appContext.themeManager.setDarkAsCustomTheme()
            }
        case .system:
            if appContext.themeManager.themeType != .standard {
                appContext.themeManager.setStandardTheme()
            }
        case .violet:
            if !(appContext.themeManager.theme.tag is VioletThemeTag) || appContext.themeManager.themeType == .standard {
                appContext.themeManager.setCustomTheme(.violet)
            }
        }
    }
}
