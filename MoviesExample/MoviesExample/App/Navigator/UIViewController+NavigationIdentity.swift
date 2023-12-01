//
//  UIViewController+NavigationIdentity.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import UIKit

extension UIViewController {
    public var navigationIdentity: (any NavigationIdentity)? {
        get { (objc_getAssociatedObject(self, &navigationIdentityKey) as? (any NavigationIdentity)) }
        set { objc_setAssociatedObject(self, &navigationIdentityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private var navigationIdentityKey = "navigationIdentityKey"

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
        }
        // TODO: - Split
        return nil
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
}

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
