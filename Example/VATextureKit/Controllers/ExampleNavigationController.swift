//
//  ExampleNavigationController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ExampleNavigationController: VANavigationController {
    
    override func configureTheme() {
        super.configureTheme()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.navigationBarBackgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.navigationBarForegroundColor]
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = theme.navigationBarBackgroundColor
            navigationBar.tintColor = theme.navigationBarForegroundColor
        }
    }
}
