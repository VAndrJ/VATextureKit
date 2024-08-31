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

public enum VAThemeFont: Hashable {
    case name(_ name: String, size: CGFloat)
    case descriptor(_ descriptor: UIFontDescriptor, size: CGFloat)
    case design(_ design: VAFontDesign, size: CGFloat, weight: UIFont.Weight)
}

/// "Backported" system theme.
open class VATheme: NSObject, @unchecked Sendable {
    public var tag: VAThemeTag
    public var userInterfaceStyle: VAUserInterfaceStyle
    public var statusBarStyle: UIStatusBarStyle
    public var barStyle: UIBarStyle
    public var label: UIColor
    public var secondaryLabel: UIColor
    public var tertiaryLabel: UIColor
    public var quaternaryLabel: UIColor
    public var systemFill: UIColor
    public var secondarySystemFill: UIColor
    public var tertiarySystemFill: UIColor
    public var quaternarySystemFill: UIColor
    public var placeholderText: UIColor
    public var systemBackground: UIColor
    public var secondarySystemBackground: UIColor
    public var tertiarySystemBackground: UIColor
    public var systemGroupedBackground: UIColor
    public var secondarySystemGroupedBackground: UIColor
    public var tertiarySystemGroupedBackground: UIColor
    public var separator: UIColor
    public var opaqueSeparator: UIColor
    public var link: UIColor
    public var darkText: UIColor
    public var lightText: UIColor
    public var systemBlue: UIColor
    public var systemGreen: UIColor
    public var systemIndigo: UIColor
    public var systemOrange: UIColor
    public var systemPink: UIColor
    public var systemPurple: UIColor
    public var systemRed: UIColor
    public var systemTeal: UIColor
    public var systemYellow: UIColor
    public var systemGray: UIColor
    public var systemGray2: UIColor
    public var systemGray3: UIColor
    public var systemGray4: UIColor
    public var systemGray5: UIColor
    public var systemGray6: UIColor
    public var font: (VAThemeFont) -> UIFont
    
    public init(
        tag: VAThemeTag,
        userInterfaceStyle: VAUserInterfaceStyle,
        statusBarStyle: UIStatusBarStyle,
        barStyle: UIBarStyle,
        label: UIColor,
        secondaryLabel: UIColor,
        tertiaryLabel: UIColor,
        quaternaryLabel: UIColor,
        systemFill: UIColor,
        secondarySystemFill: UIColor,
        tertiarySystemFill: UIColor,
        quaternarySystemFill: UIColor,
        placeholderText: UIColor,
        systemBackground: UIColor,
        secondarySystemBackground: UIColor,
        tertiarySystemBackground: UIColor,
        systemGroupedBackground: UIColor,
        secondarySystemGroupedBackground: UIColor,
        tertiarySystemGroupedBackground: UIColor,
        separator: UIColor,
        opaqueSeparator: UIColor,
        link: UIColor,
        darkText: UIColor,
        lightText: UIColor,
        systemBlue: UIColor,
        systemGreen: UIColor,
        systemIndigo: UIColor,
        systemOrange: UIColor,
        systemPink: UIColor,
        systemPurple: UIColor,
        systemRed: UIColor,
        systemTeal: UIColor,
        systemYellow: UIColor,
        systemGray: UIColor,
        systemGray2: UIColor,
        systemGray3: UIColor,
        systemGray4: UIColor,
        systemGray5: UIColor,
        systemGray6: UIColor,
        font: @escaping (VAThemeFont) -> UIFont
    ) {
        self.tag = tag
        self.userInterfaceStyle = userInterfaceStyle
        self.statusBarStyle = statusBarStyle
        self.barStyle = barStyle
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.tertiaryLabel = tertiaryLabel
        self.quaternaryLabel = quaternaryLabel
        self.systemFill = systemFill
        self.secondarySystemFill = secondarySystemFill
        self.tertiarySystemFill = tertiarySystemFill
        self.quaternarySystemFill = quaternarySystemFill
        self.placeholderText = placeholderText
        self.systemBackground = systemBackground
        self.secondarySystemBackground = secondarySystemBackground
        self.tertiarySystemBackground = tertiarySystemBackground
        self.systemGroupedBackground = systemGroupedBackground
        self.secondarySystemGroupedBackground = secondarySystemGroupedBackground
        self.tertiarySystemGroupedBackground = tertiarySystemGroupedBackground
        self.separator = separator
        self.opaqueSeparator = opaqueSeparator
        self.link = link
        self.darkText = darkText
        self.lightText = lightText
        self.systemBlue = systemBlue
        self.systemGreen = systemGreen
        self.systemIndigo = systemIndigo
        self.systemOrange = systemOrange
        self.systemPink = systemPink
        self.systemPurple = systemPurple
        self.systemRed = systemRed
        self.systemTeal = systemTeal
        self.systemYellow = systemYellow
        self.systemGray = systemGray
        self.systemGray2 = systemGray2
        self.systemGray3 = systemGray3
        self.systemGray4 = systemGray4
        self.systemGray5 = systemGray5
        self.systemGray6 = systemGray6
        self.font = font
    }
}

public extension VATheme {
    static var lock = NSRecursiveLock()
    static var fontCache: [VAThemeFont: UIFont] = [:]
    static var vaLight: VATheme {
        VATheme(
            tag: VALightThemeTag(),
            userInterfaceStyle: .light,
            statusBarStyle: .darkContent,
            barStyle: .default,
            label: UIColor.rgba(0, 0, 0, 1),
            secondaryLabel: UIColor.rgba(60, 60, 67, 0.6),
            tertiaryLabel: UIColor.rgba(60, 60, 67, 0.3),
            quaternaryLabel: UIColor.rgba(60, 60, 67, 0.18),
            systemFill: UIColor.rgba(120, 120, 128, 0.2),
            secondarySystemFill: UIColor.rgba(120, 120, 128, 0.16),
            tertiarySystemFill: UIColor.rgba(118, 118, 128, 0.12),
            quaternarySystemFill: UIColor.rgba(116, 116, 128, 0.08),
            placeholderText: UIColor.rgba(60, 60, 67, 0.3),
            systemBackground: UIColor.rgba(255, 255, 255, 1.0),
            secondarySystemBackground: UIColor.rgba(242, 242, 247, 1),
            tertiarySystemBackground: UIColor.rgba(255, 255, 255, 1),
            systemGroupedBackground: UIColor.rgba(242, 242, 247, 1),
            secondarySystemGroupedBackground: UIColor.rgba(255, 255, 255, 1),
            tertiarySystemGroupedBackground: UIColor.rgba(242, 242, 247, 1),
            separator: UIColor.rgba(60, 60, 67, 0.29),
            opaqueSeparator: UIColor.rgba(198, 198, 200, 1),
            link: UIColor.rgba(0, 122, 255, 1),
            darkText: UIColor.rgba(0, 0, 0, 1),
            lightText: UIColor.rgba(255, 255, 255, 0.6),
            systemBlue: UIColor.rgba(0, 122, 255, 1),
            systemGreen: UIColor.rgba(52, 199, 89, 1),
            systemIndigo: UIColor.rgba(88, 86, 214, 1),
            systemOrange: UIColor.rgba(255, 149, 0, 1),
            systemPink: UIColor.rgba(255, 45, 85, 1),
            systemPurple: UIColor.rgba(175, 82, 222, 1),
            systemRed: UIColor.rgba(255, 59, 48, 1),
            systemTeal: UIColor.rgba(90, 200, 250, 1),
            systemYellow: UIColor.rgba(255, 204, 0, 1),
            systemGray: UIColor.rgba(142, 142, 147, 1),
            systemGray2: UIColor.rgba(174, 174, 178, 1),
            systemGray3: UIColor.rgba(199, 199, 204, 1),
            systemGray4: UIColor.rgba(209, 209, 214, 1),
            systemGray5: UIColor.rgba(229, 229, 234, 1),
            systemGray6: UIColor.rgba(242, 242, 247, 1),
            font: getDefaultThemeFont(_:)
        )
    }
    static var vaDark: VATheme {
        VATheme(
            tag: VADarkThemeTag(),
            userInterfaceStyle: .dark,
            statusBarStyle: .lightContent,
            barStyle: .black,
            label: UIColor.rgba(255, 255, 255, 1),
            secondaryLabel: UIColor.rgba(235, 235, 245, 0.6),
            tertiaryLabel: UIColor.rgba(235, 235, 245, 0.3),
            quaternaryLabel: UIColor.rgba(235, 235, 245, 0.18),
            systemFill: UIColor.rgba(120, 120, 128, 0.36),
            secondarySystemFill: UIColor.rgba(120, 120, 128, 0.32),
            tertiarySystemFill: UIColor.rgba(118, 118, 128, 0.24),
            quaternarySystemFill: UIColor.rgba(118, 118, 128, 0.18),
            placeholderText: UIColor.rgba(235, 235, 245, 0.3),
            systemBackground: UIColor.rgba(0, 0, 0, 1),
            secondarySystemBackground: UIColor.rgba(28, 28, 30, 1),
            tertiarySystemBackground: UIColor.rgba(44, 44, 46, 1),
            systemGroupedBackground: UIColor.rgba(0, 0, 0, 1),
            secondarySystemGroupedBackground: UIColor.rgba(28, 28, 30, 1),
            tertiarySystemGroupedBackground: UIColor.rgba(44, 44, 46, 1),
            separator: UIColor.rgba(84, 84, 88, 0),
            opaqueSeparator: UIColor.rgba(56, 56, 58, 1),
            link: UIColor.rgba(9, 132, 255, 1),
            darkText: UIColor.rgba(0, 0, 0, 1),
            lightText: UIColor.rgba(255, 255, 255, 0.6),
            systemBlue: UIColor.rgba(10, 132, 255, 1),
            systemGreen: UIColor.rgba(48, 209, 88, 1),
            systemIndigo: UIColor.rgba(94, 92, 230, 1),
            systemOrange: UIColor.rgba(255, 159, 10, 1),
            systemPink: UIColor.rgba(255, 55, 95, 1),
            systemPurple: UIColor.rgba(191, 90, 242, 1),
            systemRed: UIColor.rgba(255, 69, 58, 1),
            systemTeal: UIColor.rgba(100, 210, 255, 1),
            systemYellow: UIColor.rgba(255, 214, 10, 1),
            systemGray: UIColor.rgba(142, 142, 147, 1),
            systemGray2: UIColor.rgba(99, 99, 102, 1),
            systemGray3: UIColor.rgba(72, 72, 74, 1),
            systemGray4: UIColor.rgba(58, 58, 60, 1),
            systemGray5: UIColor.rgba(44, 44, 46, 1),
            systemGray6: UIColor.rgba(28, 28, 30, 1),
            font: getDefaultThemeFont(_:)
        )
    }

    static func getDefaultThemeFont(_ themeFont: VAThemeFont) -> UIFont {
        lock.lock()
        defer { lock.unlock() }

        if let font = fontCache[themeFont] {
            return font
        }

        let font: UIFont
        switch themeFont {
        case let .name(name, size):
            font = UIFont(name: name, size: size)!
        case let .descriptor(descriptor, size):
            font = UIFont(descriptor: descriptor, size: size)
        case let .design(fontDesign, size, weight):
            switch fontDesign {
            case .default:
                font = UIFont.systemFont(ofSize: size, weight: weight)
            case .monospaced:
                font = UIFont.monospacedSystemFont(ofSize: size, weight: weight)
            case .monospacedDigits:
                font = UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
            case .italic:
                font = UIFont.italicSystemFont(ofSize: size)
            }
        }
        fontCache[themeFont] = font

        return font
    }
}

public extension UIColor {

    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        .init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
