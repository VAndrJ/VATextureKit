//
//  VATheme+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

public class MovieThemeTag: VAThemeTag {}

extension VATheme {
    static var moviesTheme: VATheme {
        let theme: VATheme = .vaLight
        theme.tag = MovieThemeTag()
        
        return theme
    }
}

// swiftlint:disable force_unwrapping
extension VATheme {
    var primary: UIColor { R.color.primary()! }
    var secondary: UIColor { R.color.secondary()! }
    var tertiary: UIColor { R.color.tertiary()! }
    var tabTint: UIColor { R.color.tabTint()! }
}
// swiftlint:enable force_unwrapping
