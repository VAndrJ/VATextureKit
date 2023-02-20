//
//  Navigator.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class Navigator {
    let screenFactory: ScreenFactory
    let navigationController: UINavigationController
    
    private var childNavigators: [Navigator] = []
    
    init(
        screenFactory: ScreenFactory,
        navigationController: UINavigationController,
        initialRoute: NavigationRoute? = nil
    ) {
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        
        if let initialRoute {
            navigationController.setViewControllers(
                [screenFactory.create(route: initialRoute, navigator: self)],
                animated: false
            )
        }
    }
    
    func navigate(to route: NavigationRoute, animated: Bool = true) {
        navigationController.pushViewController(
            screenFactory.create(route: route, navigator: self),
            animated: animated
        )
    }
    
//    func push(route: NavigationRoute) {
//        let navigator = Navigator(
//            screenFactory: screenFactory,
//            navigationController: ExampleNavigationController(),
//            initialRoute: route
//        )
//        navigationController.pushViewController(navigator.navigationController, animated: true)
//        childNavigators.append(navigator)
//    }
}

class ScreenFactory {
    func create(route: NavigationRoute, navigator: Navigator) -> UIViewController {
        switch route {
        case .main:
            return MainViewController(viewModel: MainViewModel(navigator: navigator))
        case .apearance:
            return AppearanceController()
        }
    }
}
