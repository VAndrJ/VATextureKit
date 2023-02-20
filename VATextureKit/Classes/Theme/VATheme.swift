//
//  VATheme.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAThemeTag {
    public init() {}
}

public class VALightThemeTag: VAThemeTag {}

public class VADarkThemeTag: VAThemeTag {}

open class VATheme {
    public let tag: VAThemeTag
    public let userInterfaceStyle: UIUserInterfaceStyle
    public let statusBarStyle: UIStatusBarStyle
    public let barStyle: UIBarStyle
    public let background: UIColor
    public let label: UIColor
    public let secondaryLabel: UIColor
    
    public init(
        tag: VAThemeTag,
        userInterfaceStyle: UIUserInterfaceStyle,
        statusBarStyle: UIStatusBarStyle,
        barStyle: UIBarStyle,
        background: UIColor,
        label: UIColor,
        secondaryLabel: UIColor
    ) {
        self.tag = tag
        self.userInterfaceStyle = userInterfaceStyle
        self.statusBarStyle = statusBarStyle
        self.barStyle = barStyle
        self.background = background
        self.label = label
        self.secondaryLabel = secondaryLabel
    }
}

public extension VATheme {
    static var vaLight: VATheme {
        VATheme(
            tag: VALightThemeTag(),
            userInterfaceStyle: .light,
            statusBarStyle: .default,
            barStyle: .default,
            background: .white,
            label: UIColor.rgba(0, 0, 0),
            secondaryLabel: UIColor.rgba(60, 60, 67, 0.6)
        )
    }
    static var vaDark: VATheme {
        VATheme(
            tag: VADarkThemeTag(),
            userInterfaceStyle: .dark,
            statusBarStyle: .lightContent,
            barStyle: .black,
            background: .black,
            label: UIColor.rgba(255, 255, 255),
            secondaryLabel: UIColor.rgba(235, 235, 245, 0.6)
        )
    }
}

public extension UIColor {
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
