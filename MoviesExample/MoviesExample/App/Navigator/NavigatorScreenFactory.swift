//
//  NavigatorScreenFactory.swift
//  MoviesExample
//
//  Created by VAndrJ on 02.12.2023.
//

import Foundation

protocol NavigatorScreenFactory {

    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> UIViewController
    func embedInNavigationControllerIfNeeded(controller: UIViewController) -> UIViewController
}
