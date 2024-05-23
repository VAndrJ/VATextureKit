//
//  UIViewController+NavigationTransition.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

import UIKit

public extension UIViewController {
    @UniquePointerAddress static var isTransitionAnimationEnabledKey

    var isTransitionAnimationEnabled: Bool {
        get { (objc_getAssociatedObject(self, Self.isTransitionAnimationEnabledKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, Self.isTransitionAnimationEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @discardableResult
    func withAnimatedTransitionEnabled() -> Self {
        isTransitionAnimationEnabled = true

        return self
    }
}

@propertyWrapper
public class UniquePointerAddress {
    public var wrappedValue: UnsafeRawPointer { UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()) }

    public init() {}
}
