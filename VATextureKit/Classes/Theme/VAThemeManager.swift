//
//  VAThemeManager.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAThemeManager {
    public enum ThemeType {
        case standard
        case custom
    }
    
    public static let themeDidChangedNotification = Notification.Name("VAThemeManager.themeDidChangedNotification")
    
    public private(set) var theme: VATheme
    public private(set) var themeType: ThemeType
    
    private let standardLightTheme: VATheme
    private let standardDarkTheme: VATheme
    private var userInterfaceStyle: UIUserInterfaceStyle
    
    public init(
        customTheme: VATheme,
        standardLightTheme: VATheme,
        standardDarkTheme: VATheme,
        userInterfaceStyle: UIUserInterfaceStyle = .light
    ) {
        self.theme = customTheme
        self.themeType = .custom
        self.standardLightTheme = standardLightTheme
        self.standardDarkTheme = standardDarkTheme
        self.userInterfaceStyle = userInterfaceStyle
    }
    
    public init(
        standardLightTheme: VATheme,
        standardDarkTheme: VATheme,
        userInterfaceStyle: UIUserInterfaceStyle = .light
    ) {
        self.theme = userInterfaceStyle == .dark ? standardDarkTheme : standardLightTheme
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
            NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: self)
        }
    }
    
    public func setCustomTheme(_ customTheme: VATheme) {
        themeType = .custom
        theme = customTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: self)
    }
    
    public func setLightAsCustomTheme() {
        themeType = .custom
        theme = standardLightTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: self)
    }
    
    public func setDarkAsCustomTheme() {
        themeType = .custom
        theme = standardDarkTheme
        NotificationCenter.default.post(name: Self.themeDidChangedNotification, object: self)
    }
}
