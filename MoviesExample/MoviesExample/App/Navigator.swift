//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class Navigator {
    let id = UUID()
    let screenFactory: ScreenFactory

    private let bag = DisposeBag()
    private weak var window: UIWindow?

    init(
        window: UIWindow?,
        screenFactory: ScreenFactory
    ) {
        self.window = window
        self.screenFactory = screenFactory
    }

    func navigate(
        destination: NavigationDestination,
        strategy: NavigationStrategy,
        animated: Bool = true
    ) -> Responder? {
        switch strategy {
        case .replaceWindowRoot:
            guard let controller = screenFactory.assembleScreen(identity: destination.identity, navigator: self) else {
                return nil
            }

            if window?.rootViewController == nil {
                window?.rootViewController = controller
                window?.makeKeyAndVisible()
            } else {
                window?.set(rootViewController: controller)
            }
            return controller
        case .push:
            guard let controller = screenFactory.assembleScreen(identity: destination.identity, navigator: self) else {
                return nil
            }

            window?.topViewController?.navigationController?.pushViewController(
                controller,
                animated: animated
            )
            return controller
        case .pushOrPopToExisting:
            if let controller = window?.rootViewController?.findController(identity: destination.identity) {
                controller.navigationController?.popToViewController(controller, animated: animated)

                return nil
            } else {
                guard let controller = screenFactory.assembleScreen(identity: destination.identity, navigator: self) else {
                    return nil
                }

                window?.topViewController?.navigationController?.pushViewController(
                    controller,
                    animated: animated
                )
                return controller
            }
        }
    }

    func performNavigation(
        destination: NavigationDestination,
        strategy: NavigationStrategy,
        animated: Bool = true
    ) {
        let responder = navigate(destination: destination, strategy: strategy, animated: animated)
        (window?.topViewController as? Responder)?.nextEventResponder = responder
    }

//    func performNavigation(to route: NavigationRoute, animated: Bool = true) {
//        let responder = navigate(to: route, animated: animated)
//        (window?.topViewController as? Responder)?.nextEventResponder = responder
//    }

//    func navigate(to route: NavigationRoute, animated: Bool = true) -> Responder? {
//        switch route {
//        case let .present(route):
//            return nil //present(route: route)
//        case let .movie(movie):
//            return navigate(
//                destination: .init(
//                    identity: MovieDetailsNavigationIdentity(id: movie.id, details: movie)
//                ),
//                strategy: .pushOrPopToExisting,
//                animated: animated
//            )
//        case let .actor(actor):
//            let controller = screenFactory.create(screen: route.screen, navigator: self)
////            navigationController.present(controller, animated: true)
//            return controller
//        default:
//            let controller = screenFactory.create(screen: route.screen, navigator: self)
////            navigationController.pushViewController(
////                controller,
////                animated: animated
////            )
//            return controller
//        }
//    }

//    func closeAllAndPop(to controller: UIViewController?) {
//        navigationController.presentedViewController?.dismiss(animated: false)
//        if let controller {
//            navigationController.popToViewController(controller, animated: false)
//        }
//    }
}

extension Navigator: Responder {
    var nextEventResponder: Responder? {
        get { nil }
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
    case replaceWindowRoot
    case push
    case pushOrPopToExisting
}

public protocol TabsNavigationIdentity: NavigationIdentity {
    var tabsIdentity: [NavigationIdentity] { get }
}

public struct MainTabsNavigationIdentity: TabsNavigationIdentity {
    public let tabsIdentity: [NavigationIdentity]

    public func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? MainTabsNavigationIdentity else {
            return false
        }
        guard other.tabsIdentity.count == tabsIdentity.count else {
            return false
        }

        // swiftlint:disable for_where
        for pair in zip(tabsIdentity, other.tabsIdentity) {
            if !pair.0.isEqual(to: pair.1) {
                return false
            }
        }
        // swiftlint:enable for_where

        return true
    }
}

struct MainNavigationIdentity: NavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard other is MainNavigationIdentity else {
            return false
        }

        return true
    }
}

struct NavNavigationIdentity: NavigationIdentity {
    var childIdentity: NavigationIdentity?

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? NavNavigationIdentity else {
            return false
        }

        return childIdentity?.isEqual(to: other.childIdentity) == true
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

extension UIWindow {

    func set(rootViewController newRootViewController: UIViewController, transition: CATransition? = nil) {
        let previousViewController = rootViewController
        if let transition {
            layer.add(transition, forKey: kCATransition)
        }
        rootViewController = newRootViewController
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        if #available(iOS 13.0, *) {
            // In iOS 13 we don't want to remove the transition view as it'll create a blank screen
        } else {
            if let transitionViewClass = NSClassFromString("UITransitionView") {
                for subview in subviews where subview.isKind(of: transitionViewClass) {
                    subview.removeFromSuperview()
                }
            }
        }
        if let previousViewController {
            previousViewController.dismiss(animated: false) {
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
