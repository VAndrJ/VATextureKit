//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class Navigator: Responder {
    enum NavigationDestination {
        case identity(NavigationIdentity)
        case controller(UIViewController)

        var identity: NavigationIdentity? {
            switch self {
            case let .identity(identity):
                return identity
            case let .controller(controller):
                return controller.navigationIdentity
            }
        }
    }

    let screenFactory: ScreenFactory

    private(set) weak var window: UIWindow?

    init(
        window: UIWindow?,
        screenFactory: ScreenFactory
    ) {
        self.window = window
        self.screenFactory = screenFactory
    }

    // swiftlint:disable function_body_length
    @discardableResult
    func navigate(
        destination: NavigationDestination,
        source: NavigationIdentity? = nil,
        strategy: NavigationStrategy,
        sourceStrategy: NavigationStrategy = .present,
        event: ResponderEvent? = nil,
        animated: Bool = true
    ) -> Responder? {
        let eventController: (UIViewController & Responder)?
        var navigatorEvent: ResponderEvent?
        switch strategy {
        case let .replaceWindowRoot(transition):
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            replaceWindowRoot(controller: controller, transition: transition)
            eventController = controller as? UIViewController & Responder
        case .present:
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            present(controller: controller, animated: animated)
            eventController = controller as? UIViewController & Responder
        case .presentOrCloseToExisting:
            if let controller = window?.rootViewController?.findController(destination: destination) {
                closeNavigationPresented(controller: controller, animated: animated)
                eventController = controller as? UIViewController & Responder
                navigatorEvent = ResponderPoppedToExistingEvent()
            } else {
                return navigate(
                    destination: destination,
                    source: source,
                    strategy: .present,
                    event: event,
                    animated: animated
                )
            }
        case let .push(alwaysEmbedded):
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            selectTabIfNeeded(
                source: source ?? destination.identity?.fallbackSource,
                controller: window?.topViewController,
                completion: { [self] sourceController in
                    if !push(sourceController: sourceController, controller: controller, animated: animated) {
                        navigate(
                            destination: .controller(alwaysEmbedded ? screenFactory.embedInNavigationControllerIfNeeded(controller: controller) : controller),
                            source: source,
                            strategy: [
                                .push(alwaysEmbedded: true),
                                .push(alwaysEmbedded: false),
                                .pushOrPopToExisting(alwaysEmbedded: true),
                                .pushOrPopToExisting(alwaysEmbedded: false)
                            ].contains(sourceStrategy) ? .present : sourceStrategy,
                            sourceStrategy: sourceStrategy,
                            event: event,
                            animated: animated
                        )
                    }
                }
            )
            eventController = controller as? UIViewController & Responder
        case let .pushOrPopToExisting(alwaysEmbedded):
            if let controller = window?.rootViewController?.findController(destination: destination) {
                closeNavigationPresented(controller: controller, animated: animated)
                selectTabIfNeeded(source: source ?? destination.identity?.fallbackSource, controller: controller)
                eventController = controller as? (UIViewController & Responder)
                navigatorEvent = ResponderPoppedToExistingEvent()
            } else {
                return navigate(
                    destination: destination,
                    source: source,
                    strategy: .push(alwaysEmbedded: alwaysEmbedded),
                    event: event,
                    animated: animated
                )
            }
        }
        if let event {
            Task {
                await eventController?.handle(event: event)
            }
        }
        if let navigatorEvent {
            Task {
                await eventController?.handle(event: navigatorEvent)
            }
        }

        return eventController
    }
    // swiftlint:enable function_body_length

    func getScreen(destination: NavigationDestination) -> UIViewController? {
        switch destination {
        case let .identity(identity):
            return screenFactory.assembleScreen(identity: identity, navigator: self)
        case let .controller(controller):
            return controller
        }
    }

    private func push(sourceController: UIViewController?, controller: UIViewController, animated: Bool) -> Bool {
        closeNavigationPresented(controller: sourceController, animated: animated)
        let topViewController = window?.topViewController
        if let navigationController = topViewController?.orNavigationController {
            navigationController.pushViewController(
                controller,
                animated: animated
            )

            return true
        } else {
            return false
        }
    }

    private func present(controller: UIViewController, animated: Bool) {
        if window?.rootViewController != nil {
            window?.topViewController?.present(controller, animated: animated)
        } else {
            var transition: CATransition?
            if animated {
                transition = CATransition()
                transition?.duration = 0.3
                transition?.type = .fade
            }
            replaceWindowRoot(controller: controller, transition: transition)
        }
    }

    private func replaceWindowRoot(controller: UIViewController, transition: CATransition?) {
        if window?.rootViewController == nil {
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
        } else {
            window?.set(rootViewController: controller, transition: transition)
        }
    }

    private func closeNavigationPresented(controller: UIViewController?, animated: Bool) {
        if let controller {
            controller.presentedViewController?.dismiss(animated: animated)
            controller.navigationController?.popToViewController(controller, animated: animated)
        }
    }

    private func selectTabIfNeeded(
        source: NavigationIdentity?,
        controller: UIViewController?,
        completion: ((UIViewController?) -> Void)? = nil
    ) {
        if let source, let tabBarController = controller?.findTabBarController() {
            for index in (tabBarController.viewControllers ?? []).indices {
                if let sourceController = tabBarController.viewControllers?[index].findController(identity: source) {
                    if tabBarController.selectedIndex != index {
                        tabBarController.selectedIndex = index
                        mainAsync(after: 0.4) {
                            completion?(sourceController)
                        }
                    } else {
                        completion?(sourceController)
                    }
                    return
                }
            }
        }
        completion?(nil)
    }

    // MARK: - Responder

    var nextEventResponder: Responder? {
        get { nil }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)

        return await nextEventResponder?.handle(event: event) ?? false
    }
}
