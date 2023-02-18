//
//  VAThemeManager.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
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
    private var userInterfaceStyle: UIUserInterfaceStyle
    
    public init(customTheme: Theme, standardLightTheme: Theme, standardDarkTheme: Theme, userInterfaceStyle: UIUserInterfaceStyle = .light) {
        self.theme = customTheme
        self.themeType = .custom
        self.standardLightTheme = standardLightTheme
        self.standardDarkTheme = standardDarkTheme
        self.userInterfaceStyle = userInterfaceStyle
    }
    
    public init(standardLightTheme: Theme, standardDarkTheme: Theme, userInterfaceStyle: UIUserInterfaceStyle = .light) {
        self.theme = standardLightTheme
        self.themeType = .standard
        self.standardLightTheme = standardLightTheme
        self.standardDarkTheme = standardDarkTheme
        self.userInterfaceStyle = userInterfaceStyle
    }
    
    public func setStandardTheme() {
        themeType = .standard
        updateStandardThemeIfNeeded(userInterfaceStyle: userInterfaceStyle)
    }
    
    public func updateStandardThemeIfNeeded(userInterfaceStyle: UIUserInterfaceStyle) {
        self.userInterfaceStyle = userInterfaceStyle
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
    
    public func setLightAsCustomTheme() {
        themeType = .custom
        theme = standardLightTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: nil)
    }
    
    public func setDarkAsCustomTheme() {
        themeType = .custom
        theme = standardDarkTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: nil)
    }
}
