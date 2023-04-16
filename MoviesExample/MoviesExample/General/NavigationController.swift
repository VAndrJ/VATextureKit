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
        navigationBar.tintColor = theme.secondary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if viewControllers.isNotEmpty {
            for i in viewControllers.indices.dropLast(1).reversed() where (viewControllers[i] as? NavigationClosable)?.isNotImportant == true {
                viewControllers.remove(at: i)
            }
        }
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
