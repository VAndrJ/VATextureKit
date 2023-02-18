//
//  AppDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02/18/2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import VATextureKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = MainViewController(node: MainControllerNode())
        window?.makeKeyAndVisible()
        configure()
        
        return true
    }
    
    private func configure() {
        ASDisplayNode.shouldDebugLabelBeHidden = false
    }
}
