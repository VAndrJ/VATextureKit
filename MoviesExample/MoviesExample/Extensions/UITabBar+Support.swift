//
//  UITabBar+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

public extension UITabBar {

    func configureAppearance(theme: VATheme) {
        clipsToBounds = true
        isTranslucent = false
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = theme.systemBackground
        appearance.stackedLayoutAppearance.selected.iconColor = theme.secondary
        appearance.stackedLayoutAppearance.normal.iconColor = theme.tabTint
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: theme.secondary]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: theme.tabTint]
        standardAppearance = appearance
        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = appearance
        }
    }
}
