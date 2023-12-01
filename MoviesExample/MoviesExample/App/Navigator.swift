//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class Navigator: Hashable, Equatable {
    nonisolated static func == (lhs: Navigator, rhs: Navigator) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let screenFactory: ScreenFactory
    let navigationController: NavigationController

    private weak var parent: Navigator?
//    private var childNavigators: Set<Navigator> = []
    private let bag = DisposeBag()
    private weak var window: UIWindow?

    init(
        window: UIWindow?,
        screenFactory: ScreenFactory,
        navigationController: NavigationController,
        initialRoute: NavigationRoute? = nil,
        parent: Navigator? = nil
    ) {
        self.window = window
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        self.parent = parent

        if let initialRoute {
            navigationController.setViewControllers(
                [screenFactory.create(screen: initialRoute.screen, navigator: self)],
                animated: false
            )
        }
    }

    init(
        window: UIWindow?,
        screenFactory: ScreenFactory,
        navigationController: NavigationController,
        flow: Flow,
        parent: Navigator? = nil
    ) {
        self.window = window
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        self.parent = parent

        navigationController.setViewControllers(
            screenFactory.create(flow: flow, navigator: self),
            animated: false
        )
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func navigate(
        destination: NavigationDestination,
        animated: Bool = true
    ) -> Responder? {
        switch destination.strategy {
        case .push:
            guard let controller = screenFactory.assembleScreen(identity: destination.identity, navigator: self) else {
                return nil
            }

            navigationController.pushViewController(
                controller,
                animated: animated
            )
            return controller
        case .pushOrPopToExisting:
            if let controller = navigationController.findController(identity: destination.identity) {
                controller.navigationController?.popToViewController(controller, animated: animated)

                return nil
            } else {
                guard let controller = screenFactory.assembleScreen(identity: destination.identity, navigator: self) else {
                    return nil
                }

                navigationController.pushViewController(
                    controller,
                    animated: animated
                )
                return controller
            }
        }
    }

    func performNavigation(destination: NavigationDestination, animated: Bool = true) {
        let responder = navigate(destination: destination, animated: animated)
        (window?.topViewController as? Responder)?.nextEventResponder = responder
    }

    func performNavigation(to route: NavigationRoute, animated: Bool = true) {
        let responder = navigate(to: route, animated: animated)
        (window?.topViewController as? Responder)?.nextEventResponder = responder
    }

    func navigate(to route: NavigationRoute, animated: Bool = true) -> Responder? {
        switch route {
        case let .present(route):
            return nil //present(route: route)
        case let .movie(movie):
            return navigate(
                destination: .init(
                    identity: MovieDetailsNavigationIdentity(id: movie.id, details: movie),
                    strategy: .pushOrPopToExisting
                ),
                animated: animated
            )
        case let .actor(actor):
            let controller = screenFactory.create(screen: route.screen, navigator: self)
            navigationController.present(controller, animated: true)
            return controller
        default:
            let controller = screenFactory.create(screen: route.screen, navigator: self)
            navigationController.pushViewController(
                controller,
                animated: animated
            )
            return controller
        }
    }

    func closeAllAndPop(to controller: UIViewController?) {
        navigationController.presentedViewController?.dismiss(animated: false)
        if let controller {
            navigationController.popToViewController(controller, animated: false)
        }
    }

//    func getChildNavigator(route: NavigationRoute? = nil) -> Navigator {
//        let navigator = Navigator(
//            window: window,
//            screenFactory: ScreenFactory(),
//            navigationController: NavigationController(),
//            initialRoute: route
//        )
////        _ = childNavigators.insert(navigator)
////        navigator.navigationController.onDismissed = { [weak self, weak navigator] in
////            if let navigator {
////                self?.childNavigators.remove(navigator)
////            }
////        }
//        return navigator
//    }

//    func present(route: NavigationRoute) -> Responder? {
//        let navigator = getChildNavigator(route: route)
//        navigationController.pushViewController(navigator.navigationController, animated: true)
//        return navigator
//    }
}

extension Navigator: Responder {
    var nextEventResponder: Responder? {
        get { navigationController }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}

enum NavigationRoute {
    case main
    case search
    case actor(ListActorEntity)
    case movie(ListMovieEntity)
    indirect case present(NavigationRoute)

    var screen: Screen {
        switch self {
        case .search:
            return .search
        case .main:
            return .main
        case let .actor(entity):
            return .actor(entity)
        case let .movie(entity):
            return .movie(entity)
        case .present:
            assertionFailure("Handle in Navigator")
            return .main
        }
    }
}

public enum NavigationStrategy {
    case push
    case pushOrPopToExisting
}

struct MainNavigationIdentity: NavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard other is MainNavigationIdentity else {
            return false
        }

        return true
    }
}

struct SearchNavigationIdentity: NavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard other is SearchNavigationIdentity else {
            return false
        }

        return true
    }
}

struct MovieDetailsNavigationIdentity: NavigationIdentity {
    let id: Id<Movie>
    var details: ListMovieEntity?

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? MovieDetailsNavigationIdentity else {
            return false
        }

        return self.id == other.id
    }
}

extension UIViewController {

    func findController(identity: any NavigationIdentity) -> UIViewController? {
        if navigationIdentity?.isEqual(to: identity) == true {
            return self
        } else if let navigation = self as? UINavigationController {
            for controller in navigation.viewControllers {
                if let target = controller.findController(identity: identity) {
                    return target
                }
            }
        } else if let tab = self as? UITabBarController {
            for controller in (tab.viewControllers ?? []) {
                if let target = controller.findController(identity: identity) {
                    return target
                }
            }
        }
        // TODO: - Split
        return nil
    }
}

public protocol NavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool
}

public struct NavigationDestination {
    public let identity: NavigationIdentity
    public let strategy: NavigationStrategy
}

public extension UIWindow {
    var topViewController: UIViewController? {
        topMostViewController?.topViewController(root: true)
    }

    private var topMostViewController: UIViewController? {
        var topmostViewController = rootViewController
        while let presentedViewController = topmostViewController?.presentedViewController, !presentedViewController.isBeingDismissed {
            topmostViewController = presentedViewController
        }

        return topmostViewController
    }
}

public extension UIViewController {

    func topViewController(in rootViewController: UIViewController? = nil, root: Bool = false) -> UIViewController? {
        let currentController = root ? self : rootViewController
        guard let controller = currentController else {
            return nil
        }

        if let tabBarController = controller as? UITabBarController {
            return topViewController(in: tabBarController.selectedViewController)
        } else if let navigationController = controller as? UINavigationController {
            return topViewController(in: navigationController.visibleViewController)
        } else if let presentedViewController = controller.presentedViewController {
            return topViewController(in: presentedViewController)
        }
        // TODO: - Split
        return controller
    }
}

extension UIViewController {
    public var navigationIdentity: (any NavigationIdentity)? {
        get { (objc_getAssociatedObject(self, &navigationIdentityKey) as? (any NavigationIdentity)) }
        set { objc_setAssociatedObject(self, &navigationIdentityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private var navigationIdentityKey = "navigationIdentityKey"
