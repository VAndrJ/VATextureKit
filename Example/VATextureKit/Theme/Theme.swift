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
    case purple
}

class PurpleThemeTag: VAThemeTag {}

extension VATheme {
    static var purple: VATheme {
        let theme = VATheme.vaLight
        theme.tag = PurpleThemeTag()
        theme.label = .purple
        
        return theme
    }
}

extension VATheme {
    var navigationBarForegroundColor: UIColor {
        switch tag {
        case _ as VADarkThemeTag:
            return .white
        default:
            return .black
        }
    }
}
