//
//  Theme.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
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
            userInterfaceStyle: .dark,
            statusBarStyle: .lightContent,
            barStyle: .black,
            background: .purple,
            label: .white,
            secondaryLabel: .darkGray
        )
    }
}

extension VATheme {
    var navigationBarBackgroundColor: UIColor {
        switch tag {
        case _ as VALightThemeTag:
            return .white
        default:
            return .black
        }
    }
    var navigationBarForegroundColor: UIColor {
        switch tag {
        case _ as VADarkThemeTag:
            return .white
        case _ as VioletThemeTag:
            return .green
        default:
            return .black
        }
    }
}
