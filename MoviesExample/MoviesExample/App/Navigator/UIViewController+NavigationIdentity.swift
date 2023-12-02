//
//  UIViewController+NavigationIdentity.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import UIKit

public extension UIViewController {

    func topViewController(in rootViewController: UIViewController? = nil, root: Bool = false) -> UIViewController? {
        let currentController = root ? self : rootViewController
        guard let controller = currentController else {
            return nil
        }

        var possibleController: UIViewController?
        if let tabBarController = controller as? UITabBarController {
            possibleController = tabBarController.selectedViewController
        } else if let navigationController = controller as? UINavigationController {
            possibleController = navigationController.topViewController
        } else if let presentedViewController = controller.presentedViewController {
            possibleController = presentedViewController
        }
        // TODO: - Split
        if let possibleController, !possibleController.isBeingDismissed {
            return topViewController(in: possibleController)
        } else {
            return controller
        }
    }

    func findController(controller: UIViewController) -> UIViewController? {
        if self === controller {
            return self
        } else if let navigation = self as? UINavigationController {
            for controller in navigation.viewControllers {
                if let target = controller.findController(controller: controller) {
                    return target
                }
            }
        } else if let tab = self as? UITabBarController {
            for controller in (tab.viewControllers ?? []) {
                if let target = controller.findController(controller: controller) {
                    return target
                }
            }
        } else if let presentedViewController {
            return presentedViewController.findController(controller: controller)
        }
        // TODO: - Split
        return nil
    }

    func findController(identity: NavigationIdentity) -> UIViewController? {
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
        } else if let presentedViewController {
            return presentedViewController.findController(identity: identity)
        }
        // TODO: - Split
        return nil
    }

    func findTabBarController() -> UITabBarController? {
        if let tabController = self as? UITabBarController {
            return tabController
        } else if let tabBarController {
            return tabBarController
        } else if let presentingViewController {
            return presentingViewController.findTabBarController()
        } else {
            return nil
        }
    }
}

extension UIViewController {

    var orNavigationController: UINavigationController? {
        (self as? UINavigationController) ?? navigationController
    }

    func findController(destination: Navigator.NavigationDestination) -> UIViewController? {
        switch destination {
        case let .identity(identity):
            return findController(identity: identity)
        case let .controller(controller):
            return findController(controller: controller)
        }
    }
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
        if #unavailable(iOS 13.0) {
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

extension UIWindow {

    func findController(destination: Navigator.NavigationDestination) -> UIViewController? {
        rootViewController?.findController(destination: destination)
    }
}

extension UIViewController {
    public var navigationIdentity: (any NavigationIdentity)? {
        get { (objc_getAssociatedObject(self, &navigationIdentityKey) as? (any NavigationIdentity)) }
        set { objc_setAssociatedObject(self, &navigationIdentityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private var navigationIdentityKey = "navigationIdentityKey"
