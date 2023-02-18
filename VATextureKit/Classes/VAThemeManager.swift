//
//  VAThemeManager.swift
//  VATextureKit
//
//  Created by VAndrJ on 18.02.2023.
//

import UIKit

open class VAThemeManager<Theme> {
    public enum ThemeType {
        case standard
        case custom
    }
    
    public static var themeDidChangedNotification: Notification.Name { .init("VAThemeManager.themeDidChangedNotification") }
    
    public private(set) var theme: Theme
    public private(set) var themeType: ThemeType
    
    private let standardLightTheme: Theme
    private let standardDarkTheme: Theme
    
    public init(themeType: ThemeType, theme: Theme, standardLightTheme: Theme, standardDarkTheme: Theme) {
        self.theme = theme
        self.themeType = themeType
        self.standardLightTheme = standardLightTheme
        self.standardDarkTheme = standardDarkTheme
    }
    
    public func setStandardTheme(userInterfaceStyle: UIUserInterfaceStyle) {
        themeType = .standard
        updateStandardThemeIfNeeded(userInterfaceStyle: userInterfaceStyle)
    }
    
    public func updateStandardThemeIfNeeded(userInterfaceStyle: UIUserInterfaceStyle) {
        if themeType == .standard {
            if userInterfaceStyle == .dark {
                theme = standardDarkTheme
            } else {
                theme = standardLightTheme
            }
            NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: nil)
        }
    }
    
    public func setCustomTheme(_ customTheme: Theme) {
        themeType = .custom
        theme = customTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: nil)
    }
}
