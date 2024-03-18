//
//  ExampleNavigationController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit
import VANavigator

struct ExampleNavigationControllerIdentity: DefaultNavigationIdentity {
    let root: NavigationIdentity
}

final class ExampleNavigationController: VANavigationController {
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.secondarySystemBackground
            appearance.backgroundEffect = nil
            appearance.titleTextAttributes = [.foregroundColor: theme.label]
            appearance.shadowColor = nil
            navigationBar.compactAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = nil
            navigationBar.compactScrollEdgeAppearance = nil
        } else {
            navigationBar.barTintColor = theme.secondarySystemBackground
            navigationBar.titleTextAttributes = [.foregroundColor: theme.label]
        }
    }
}
