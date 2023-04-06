//
//  AppDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import UIKit
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
        func launch() {
            window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
            configure()
            window?.rootViewController = appNavigator.navigationController
            window?.makeKeyAndVisible()
        }
        #if DEBUG || targetEnvironment(simulator)
        if Environment.isTesting {
            window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
            return true
        } else {
            launch()
        }
        #else
        launch()
        #endif
        
        return true
    }
    
    private func configure() {
        ASDisplayNode.shouldDebugLabelBeHidden = false
        themeManager.checkInitialTheme()
    }
}
