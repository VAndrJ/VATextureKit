//
//  VAThemeManager.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

/// Custom `UserInterfaceStyle` replacement enum to use with iOS <12.
public enum VAUserInterfaceStyle: Int {
    case unspecified = 0
    case light = 1
    case dark = 2

    @available(iOS 12.0, *)
    public init(userInterfaceStyle: UIUserInterfaceStyle) {
        switch userInterfaceStyle {
        case .unspecified: self = .unspecified
        case .light: self = .light
        case .dark: self = .dark
        @unknown default: self = .light
        }
    }

    @available(iOS 12.0, *)
    var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .unspecified: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

public protocol VAThemeObserver: AnyObject {

    func themeDidChanged(to newTheme: VATheme)
}

open class VAThemeManager {
    public enum ThemeType {
        case standard
        case custom
    }
    
    public private(set) var theme: VATheme
    public private(set) var themeType: ThemeType
    
    private let standardLightTheme: VATheme
    private let standardDarkTheme: VATheme
    private var userInterfaceStyle: VAUserInterfaceStyle
    private var themeObservers: [ObjectIdentifier: () -> VAThemeObserver?] = [:]
    
    public init(
        customTheme: VATheme,
        standardLightTheme: VATheme,
        standardDarkTheme: VATheme,
        userInterfaceStyle: VAUserInterfaceStyle = .light
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
        userInterfaceStyle: VAUserInterfaceStyle = .light
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
    
    public func updateStandardThemeIfNeeded(userInterfaceStyle: VAUserInterfaceStyle) {
        self.userInterfaceStyle = userInterfaceStyle
        if themeType == .standard {
            if userInterfaceStyle == .dark {
                theme = standardDarkTheme
            } else {
                theme = standardLightTheme
            }
            themeObservers.values.forEach { $0()?.themeDidChanged(to: theme) }
        }
    }
    
    public func setCustomTheme(_ customTheme: VATheme) {
        themeType = .custom
        theme = customTheme
        themeObservers.values.forEach { $0()?.themeDidChanged(to: theme) }
    }
    
    public func setLightAsCustomTheme() {
        themeType = .custom
        theme = standardLightTheme
        themeObservers.values.forEach { $0()?.themeDidChanged(to: theme) }
    }
    
    public func setDarkAsCustomTheme() {
        themeType = .custom
        theme = standardDarkTheme
        themeObservers.values.forEach { $0()?.themeDidChanged(to: theme) }
    }

    public func addThemeObserver(_ observer: VAThemeObserver) {
        themeObservers[ObjectIdentifier(observer)] = { [weak observer] in observer }
    }

    public func removeThemeObserver(_ observer: VAThemeObserver) {
        themeObservers.removeValue(forKey: ObjectIdentifier(observer))
    }
}
