//
//  AppDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

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
            if #available(iOS 12.0, *) {
                window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
            } else {
                window = VAWindow(legacyLightTheme: .vaLight, legacyDarkTheme: .vaDark)
            }
            configure()
            window?.rootViewController = appNavigator.navigationController
            window?.makeKeyAndVisible()
        }
        
        #if DEBUG && targetEnvironment(simulator)
        if Environment.isTesting {
            if #available(iOS 12.0, *) {
                window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
            } else {
                window = VAWindow(legacyLightTheme: .vaLight, legacyDarkTheme: .vaDark)
            }
            window?.rootViewController = UIViewController()
            window?.makeKeyAndVisible()

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
        #if DEBUG || targetEnvironment(simulator)
        ASDisplayNode.shouldDebugLabelBeHidden = false
        #endif
        themeManager.checkInitialTheme()
    }
}
