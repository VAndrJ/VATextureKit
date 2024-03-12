//
//  VASizedViewWrapperNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.04.2023.
//

import UIKit
import AsyncDisplayKit

/// A custom `ASDisplayNode` subclass for wrapping autolayout and self-sizing `UIView`s with various sizing options.
open class VASizedViewWrapperNode<T: UIView>: VADisplayNode {
    public enum Sizing {
        case viewHeight
        case viewWidth
        case viewSize
    }

    /// The wrapped UIView instance.
    @MainActor
    public private(set) lazy var child: T = childGetter()

    private let childGetter: @MainActor () -> T
    private let sizing: Sizing

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - actorChildGetter: A closure returning the UIView instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    @available (iOS 13.0, *)
    public init(actorChildGetter: @MainActor @escaping () -> T, sizing: Sizing) {
        self.sizing = sizing
        self.childGetter = actorChildGetter

        super.init()
    }

    /// Creates an instance of `VASizedViewWrapperNode`.
    ///
    /// - Parameters:
    ///   - childGetter: A closure returning the UIView instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    public init(childGetter: @escaping () -> T, sizing: Sizing) {
        self.sizing = sizing
        self.childGetter = childGetter

        super.init()
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        view.addSubview(child)
    }

    @MainActor
    open override func layout() {
        super.layout()

        switch sizing {
        case .viewHeight:
            let size = child.systemLayoutSizeFitting(.init(
                width: bounds.width,
                height: UIView.layoutFittingExpandedSize.height
            ))
            if !size.height.isPixelEqual(to: bounds.height) {
                let height = size.height.pixelRounded(.up)
                child.frame = CGRect(width: bounds.width, height: height)
                style.height = .points(height)
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        case .viewWidth:
            let size = child.systemLayoutSizeFitting(.init(
                width: UIView.layoutFittingExpandedSize.width,
                height: bounds.height
            ))
            if !size.width.isPixelEqual(to: bounds.width) {
                let width = size.width.pixelRounded(.up)
                child.frame = CGRect(width: width, height: bounds.height)
                style.width = .points(width)
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        case .viewSize:
            let size = child.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if !size.height.isPixelEqual(to: bounds.height) || !size.width.isPixelEqual(to: bounds.width) {
                child.frame = CGRect(
                    width: size.width.pixelRounded(.up),
                    height: size.height.pixelRounded(.up)
                )
                style.preferredSize = size
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        }
    }
}
