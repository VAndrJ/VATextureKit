//
//  Theme.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

enum Theme: Int, CaseIterable {
    case system
    case light
    case dark
    case violet
}

class VioletThemeTag: VAThemeTag {}

extension VATheme {
    static var violet: VATheme {
        VATheme(
            tag: VioletThemeTag(),
            userInterfaceStyle: .light,
            statusBarStyle: .lightContent,
            barStyle: .default,
            label: UIColor.rgba(0, 0, 0, 1),
            secondaryLabel: UIColor.rgba(65, 60, 96, 0.6),
            tertiaryLabel: UIColor.rgba(65, 60, 96, 0.3),
            quaternaryLabel: UIColor.rgba(65, 60, 96, 0.18),
            systemFill: UIColor.rgba(159, 122, 234, 0.36),
            secondarySystemFill: UIColor.rgba(159, 122, 234, 0.32),
            tertiarySystemFill: UIColor.rgba(160, 120, 235, 0.24),
            quaternarySystemFill: UIColor.rgba(160, 120, 235, 0.18),
            placeholderText: UIColor.rgba(65, 60, 96, 0.3),
            systemBackground: UIColor.rgba(255, 255, 255, 1),
            secondarySystemBackground: UIColor.rgba(247, 247, 250, 1),
            tertiarySystemBackground: UIColor.rgba(238, 238, 242, 1),
            systemGroupedBackground: UIColor.rgba(255, 255, 255, 1),
            secondarySystemGroupedBackground: UIColor.rgba(247, 247, 250, 1),
            tertiarySystemGroupedBackground: UIColor.rgba(238, 238, 242, 1),
            separator: UIColor.rgba(178, 172, 200, 0.5),
            opaqueSeparator: UIColor.rgba(198, 192, 219, 1),
            link: UIColor.rgba(125, 82, 234, 1),
            darkText: UIColor.rgba(0, 0, 0, 1),
            lightText: UIColor.rgba(255, 255, 255, 0.6),
            systemBlue: UIColor.rgba(0, 122, 255, 1),
            systemGreen: UIColor.rgba(52, 199, 89, 1),
            systemIndigo: UIColor.rgba(88, 86, 214, 1),
            systemOrange: UIColor.rgba(255, 149, 0, 1),
            systemPink: UIColor.rgba(255, 45, 85, 1),
            systemPurple: UIColor.rgba(191, 90, 242, 1),
            systemRed: UIColor.rgba(255, 59, 48, 1),
            systemTeal: UIColor.rgba(90, 200, 250, 1),
            systemYellow: UIColor.rgba(255, 204, 0, 1),
            systemGray: UIColor.rgba(142, 142, 147, 1),
            systemGray2: UIColor.rgba(99, 99, 102, 1),
            systemGray3: UIColor.rgba(72, 72, 74, 1),
            systemGray4: UIColor.rgba(58, 58, 60, 1),
            systemGray5: UIColor.rgba(44, 44, 46, 1),
            systemGray6: UIColor.rgba(28, 28, 30, 1)
        )
    }
}

extension VATheme {
    var navigationBarBackgroundColor: UIColor {
        switch tag {
        case _ as VALightThemeTag:
            return .white
        case _ as VioletThemeTag:
            return .purple
        default:
            return .black
        }
    }
    var navigationBarForegroundColor: UIColor {
        switch tag {
        case _ as VADarkThemeTag:
            return .white
        case _ as VioletThemeTag:
            return .white
        default:
            return .black
        }
    }
}
