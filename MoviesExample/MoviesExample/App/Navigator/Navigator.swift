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

    @discardableResult
    func navigate(
        destination: NavigationIdentity,
        strategy: NavigationStrategy,
        event: ResponderEvent? = nil,
        animated: Bool = true
    ) -> Responder? {
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
                    strategy: .present,
                    event: event,
                    animated: animated
                )
            }
        case .push:
            guard let controller = screenFactory.assembleScreen(identity: destination, navigator: self) else {
                return nil
            }

            window?.topViewController?.navigationController?.pushViewController(
                controller,
                animated: animated
            )
            eventController = controller
        case .pushOrPopToExisting:
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
