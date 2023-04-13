//
//  NavigationController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class NavigationController: VANavigationController {
    var onDismissed: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isBeingDismissed || isMovingFromParent {
            onDismissed?()
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        view.backgroundColor = theme.systemBackground
    }
}

extension NavigationController: Responder {
    var nextEventResponder: Responder? {
        get { viewControllers.first as? Responder }
        set {} // swiftlint:disable:this unused_setter_value
    }
    
    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}
