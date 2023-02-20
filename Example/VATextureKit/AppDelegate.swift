//
//  AppDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import VATextureKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private let themeManager = ThemeManager()
    private lazy var appNavigator = Navigator(
        screenFactory: ScreenFactory(themeManager: themeManager),
        navigationController: ExampleNavigationController(),
        initialRoute: .main
    )
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
        configure()
        window?.rootViewController = appNavigator.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func configure() {
        ASDisplayNode.shouldDebugLabelBeHidden = false
        themeManager.checkInitialTheme()
    }
}
