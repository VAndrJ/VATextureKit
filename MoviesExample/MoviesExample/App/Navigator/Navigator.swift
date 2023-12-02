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
        func selectTabIfNeeded(
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

        let eventController: (UIViewController & Responder)?
        var navigatorEvent: ResponderEvent?
        switch strategy {
        case .replaceWindowRoot:
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            if window?.rootViewController == nil {
                window?.rootViewController = controller
                window?.makeKeyAndVisible()
            } else {
                window?.set(rootViewController: controller)
            }
            eventController = controller as? UIViewController & Responder
        case .present:
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            window?.topViewController?.present(controller, animated: animated)
            eventController = controller as? UIViewController & Responder
        case .presentOrCloseToExisting:
            if let controller = window?.rootViewController?.findController(destination: destination) {
                controller.navigationController?.popToViewController(controller, animated: animated)
                if let presentedViewController = controller.presentedViewController {
                    presentedViewController.dismiss(animated: animated)
                }
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
        case .push:
            guard let controller = getScreen(destination: destination) else {
                return nil
            }

            selectTabIfNeeded(
                source: source ?? destination.identity?.fallbackSource,
                controller: window?.topViewController,
                completion: { [self] sourceController in
                    if let presentedViewController = sourceController?.presentedViewController {
                        presentedViewController.dismiss(animated: animated)
                    }
                    let topViewController = window?.topViewController
                    if let navigationController = topViewController as? UINavigationController ?? topViewController?.navigationController {
                        navigationController.pushViewController(
                            controller,
                            animated: animated
                        )
                    } else {
                        navigate(
                            destination: .controller(controller),
                            source: source,
                            strategy: [.push, .pushOrPopToExisting].contains(sourceStrategy) ? .present : sourceStrategy,
                            sourceStrategy: sourceStrategy,
                            event: event,
                            animated: animated
                        )
                    }
                }
            )
            eventController = controller as? UIViewController & Responder
        case .pushOrPopToExisting:
            if let controller = window?.rootViewController?.findController(destination: destination) {
                controller.navigationController?.popToViewController(controller, animated: animated)
                controller.presentedViewController?.dismiss(animated: animated)
                selectTabIfNeeded(source: source ?? destination.identity?.fallbackSource, controller: controller)
                eventController = controller as? (UIViewController & Responder)
                navigatorEvent = ResponderPoppedToExistingEvent()
            } else {
                return navigate(
                    destination: destination,
                    source: source,
                    strategy: .push,
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

    // MARK: - Responder

    var nextEventResponder: Responder? {
        get { nil }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        switch event {
        case let event as ResponderShortcutEvent:
            switch event.shortcut {
            case .search:
                navigate(
                    destination: .identity(SearchNavigationIdentity()),
                    source: SearchNavigationIdentity(),
                    strategy: .pushOrPopToExisting,
                    event: event
                )
            case .home:
                navigate(
                    destination: .identity(HomeNavigationIdentity()),
                    source: HomeNavigationIdentity(),
                    strategy: .pushOrPopToExisting,
                    event: event
                )
            }
            return true
        default:
            return await nextEventResponder?.handle(event: event) ?? false
        }
    }
}
