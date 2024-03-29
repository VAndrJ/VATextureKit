//
//  UIViewController+NavigationTransition.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

import UIKit

public extension UIViewController {
     var isTransitionAnimationEnabled: Bool {
        get { (objc_getAssociatedObject(self, &isTransitionAnimationEnabledKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &isTransitionAnimationEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @discardableResult
    func withAnimatedTransitionEnabled() -> Self {
        isTransitionAnimationEnabled = true
        
        return self
    }
}

private var isTransitionAnimationEnabledKey = "isTransitionAnimationEnabledKey"
