//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class Navigator {
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
        destination: NavigationIdentity,
        source: NavigationIdentity? = nil,
        strategy: NavigationStrategy,
        event: ResponderEvent? = nil,
        animated: Bool = true
    ) -> Responder? {
        func selectTabIfNeeded(
            source: NavigationIdentity?,
            controller: UIViewController?,
            completion: (() -> Void)? = nil
        ) {
            if let source, let tabBarController = controller?.tabBarController {
                // swiftlint:disable for_where
                for index in (tabBarController.viewControllers ?? []).indices {
                    if tabBarController.viewControllers?[index].findController(identity: source) != nil {
                        if tabBarController.selectedIndex != index {
                            tabBarController.selectedIndex = index
                            mainAsync(after: 0.4) {
                                completion?()
                            }
                            return
                        } else {
                            break
                        }
                    }
                }
                // swiftlint:enable for_where
            }
            completion?()
        }

        let eventController: (UIViewController & Responder)?
        var navigatorEvent: ResponderEvent?
        switch strategy {
        case .replaceWindowRoot:
            guard let controller = screenFactory.assembleScreen(identity: destination, navigator: self) else {
                return nil
            }

            if window?.rootViewController == nil {
                window?.rootViewController = controller
                window?.makeKeyAndVisible()
            } else {
                window?.set(rootViewController: controller)
            }
            eventController = controller
        case .present:
            guard let controller = screenFactory.assembleScreen(identity: destination, navigator: self) else {
                return nil
            }

            window?.topViewController?.present(controller, animated: animated)
            eventController = controller
        case .presentOrCloseToExisting:
            if let controller = window?.rootViewController?.findController(identity: destination) {
                controller.navigationController?.popToViewController(controller, animated: animated)
                if let presentedViewController = controller.presentedViewController {
                    presentedViewController.dismiss(animated: animated)
                }
                eventController = controller as? (UIViewController & Responder)
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
            guard let controller = screenFactory.assembleScreen(identity: destination, navigator: self) else {
                return nil
            }

            selectTabIfNeeded(
                source: source,
                controller: window?.topViewController,
                completion: { [self] in
                    window?.topViewController?.navigationController?.pushViewController(
                        controller,
                        animated: animated
                    )
                }
            )
            eventController = controller
        case .pushOrPopToExisting:
            if let controller = window?.rootViewController?.findController(identity: destination) {
                controller.navigationController?.popToViewController(controller, animated: animated)
                if let presentedViewController = controller.presentedViewController {
                    presentedViewController.dismiss(animated: animated)
                }
                selectTabIfNeeded(source: source, controller: controller)
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
}

// MARK: - Responder

extension Navigator: Responder {
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
                    destination: SearchNavigationIdentity(),
                    source: SearchNavigationIdentity(),
                    strategy: .pushOrPopToExisting,
                    event: event
                )
            case .home:
                navigate(
                    destination: HomeNavigationIdentity(),
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
