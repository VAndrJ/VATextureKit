//
//  ExampleNavigationController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ExampleNavigationController: VANavigationController {
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.navigationBarBackgroundColor
            appearance.backgroundEffect = nil
            appearance.titleTextAttributes = [.foregroundColor: theme.navigationBarForegroundColor]
            appearance.shadowColor = nil
            navigationBar.compactAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = nil
            navigationBar.compactScrollEdgeAppearance = nil
        } else {
            navigationBar.barTintColor = theme.navigationBarBackgroundColor
            navigationBar.tintColor = theme.navigationBarForegroundColor
        }
    }
}
