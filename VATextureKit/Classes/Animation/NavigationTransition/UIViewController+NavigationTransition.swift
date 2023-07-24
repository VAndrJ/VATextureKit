//
//  UIViewController+NavigationTransition.swift
//  Differentiator
//
//  Created by VAndrJ on 24.07.2023.
//

import Foundation

public extension UIViewController {
     var isTransitionAnimationEnabled: Bool {
        get { (objc_getAssociatedObject(self, &isTransitionAnimationEnabledKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &isTransitionAnimationEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private var isTransitionAnimationEnabledKey = "isTransitionAnimationEnabledKey"
