//
//  VATheme+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

class MovieThemeTag: VAThemeTag {}

extension VATheme {
    static var moviesTheme: VATheme {
        let theme: VATheme = .vaLight
        theme.tag = MovieThemeTag()
        
        return theme
    }
}

extension VATheme {
    var primary: UIColor { .init(resource: .primary) }
    var secondary: UIColor { .init(.secondary) }
    var tertiary: UIColor { .init(resource: .tertiary) }
    var tabTint: UIColor { .init(resource: .tabTint) }
}
