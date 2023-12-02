//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class Navigator {
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

    let screenFactory: NavigatorScreenFactory

    private(set) weak var window: UIWindow?

    init(
        window: UIWindow?,
        screenFactory: ScreenFactory
    ) {
        self.window = window
        self.screenFactory = screenFactory
    }

    @discardableResult
    func navigate(
        chain: [(destination: NavigationDestination, strategy: NavigationStrategy)],
        source: NavigationIdentity? = nil,
        event: ResponderEvent? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> Responder? {
        guard chain.isNotEmpty else {
            completion?()
            return nil
        }

        var chain = chain
        let link = chain.removeFirst()
        return navigate(
            destination: link.destination,
            source: source,
            strategy: link.strategy,
            event: event,
            animated: animated,
            completion: { [self] in
                navigate(
                    chain: chain,
                    source: link.destination.identity,
                    event: event,
                    animated: animated,
                    completion: completion
                )
            }
        )
    }

    // swiftlint:disable function_body_length
    @discardableResult
    func navigate(
        destination: NavigationDestination,
        source: NavigationIdentity? = nil,
        strategy: NavigationStrategy,
        event: ResponderEvent? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> Responder? {
        let eventController: (UIViewController & Responder)?
        var navigatorEvent: ResponderEvent?
        switch strategy {
        case let .replaceWindowRoot(transition):
            guard let controller = getScreen(destination: destination) else {
                completion?()
                return nil
            }

            replaceWindowRoot(controller: controller, transition: transition, completion: completion)
            eventController = controller as? UIViewController & Responder
        case .present:
            guard let controller = getScreen(destination: destination) else {
                completion?()
                return nil
            }

            present(controller: controller, animated: animated, completion: completion)
            eventController = controller as? UIViewController & Responder
        case .presentOrCloseToExisting:
            if let controller = window?.findController(destination: destination) {
                selectTabIfNeeded(
                    source: source ?? destination.identity?.fallbackSource,
                    controller: window?.topViewController,
                    completion: { [self] sourceController in
                        closeNavigationPresented(controller: sourceController ?? controller, animated: animated)
                        completion?()
                    }
                )
                eventController = controller as? UIViewController & Responder
                navigatorEvent = ResponderPoppedToExistingEvent()
            } else {
                return navigate(
                    destination: destination,
                    source: source,
                    strategy: .present,
                    event: event,
                    animated: animated,
                    completion: completion
                )
            }
        case let .push(alwaysEmbedded):
            guard let controller = getScreen(destination: destination) else {
                completion?()
                return nil
            }

            selectTabIfNeeded(
                source: source ?? destination.identity?.fallbackSource,
                controller: window?.topViewController,
                completion: { [self] sourceController in
                    let sourceController = sourceController?.topViewController(root: true)?.orNavigationController
                    if push(sourceController: sourceController, controller: controller, animated: animated) {
                        completion?()
                    } else {
                        navigate(
                            destination: .controller(alwaysEmbedded ? screenFactory.embedInNavigationControllerIfNeeded(controller: controller) : controller),
                            source: source,
                            strategy: .present,
                            event: event,
                            animated: animated,
                            completion: completion
                        )
                    }
                }
            )
            eventController = controller as? UIViewController & Responder
        case let .pushOrPopToExisting(alwaysEmbedded):
            if let controller = window?.topViewController?.navigationController?.findController(destination: destination) {
                closeNavigationPresented(controller: controller, animated: animated)
                selectTabIfNeeded(source: source ?? destination.identity?.fallbackSource, controller: controller)
                eventController = controller as? (UIViewController & Responder)
                completion?()
                navigatorEvent = ResponderPoppedToExistingEvent()
            } else {
                return navigate(
                    destination: destination,
                    source: source,
                    strategy: .push(alwaysEmbedded: alwaysEmbedded),
                    event: event,
                    animated: animated,
                    completion: completion
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
        dismissPresented(in: sourceController, animated: animated)
        if let navigationController = window?.topViewController?.orNavigationController {
            navigationController.pushViewController(
                controller,
                animated: animated
            )

            return true
        } else {
            return false
        }
    }

    private func present(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if window?.rootViewController != nil {
            window?.topViewController?.present(controller, animated: animated, completion: completion)
        } else {
            var transition: CATransition?
            if animated {
                transition = CATransition()
                transition?.duration = 0.3
                transition?.type = .fade
            }
            replaceWindowRoot(controller: controller, transition: transition, completion: completion)
        }
    }

    private func replaceWindowRoot(controller: UIViewController, transition: CATransition?, completion: (() -> Void)?) {
        if window?.rootViewController == nil {
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
            completion?()
        } else {
            window?.set(rootViewController: controller, transition: transition, completion: completion)
        }
    }

    private func closeNavigationPresented(controller: UIViewController?, animated: Bool) {
        if let controller {
            dismissPresented(in: controller, animated: animated)
            controller.navigationController?.popToViewController(controller, animated: animated)
        }
    }

    private func dismissPresented(in controller: UIViewController?, animated: Bool) {
        controller?.presentedViewController?.dismiss(animated: animated, completion: { [weak self] in
            if controller?.presentedViewController != nil {
                self?.dismissPresented(in: controller, animated: animated)
            }
        })
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
}
