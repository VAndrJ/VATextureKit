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
    private lazy var navigator = AppNavigator(
        window: window,
        screenFactory: AppScreenFactory(themeManager: themeManager),
        navigationInterceptor: nil
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        func launch() {
            window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
            configure()
            navigator.start()
            window?.makeKeyAndVisible()
        }
        
        #if DEBUG && targetEnvironment(simulator)
        if Environment.isTesting {
            window = VAWindow(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)
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
