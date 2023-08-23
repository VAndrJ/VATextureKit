//
//  VASizedViewWrapperNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.04.2023.
//

import UIKit
import AsyncDisplayKit

/// A custom `ASDisplayNode` subclass for wrapping `UIView` with various sizing options.
open class VASizedViewWrapperNode<T: UIView>: VADisplayNode {
    public enum Sizing {
        case viewHeight
        case viewWidth
        case viewSize
    }

    /// The wrapped UIView instance.
    public private(set) lazy var child: T = childGetter()

    private let childGetter: () -> T
    private let sizing: Sizing

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

    open override func didLoad() {
        super.didLoad()

        view.addSubview(child)
    }

    open override func layout() {
        super.layout()

        child.sizeToFit()
        switch sizing {
        case .viewHeight:
            if child.frame.height.rounded(.up) != bounds.height.rounded(.up) || child.frame.height.isZero {
                child.frame.size = CGSize(width: bounds.width, height: UIView.layoutFittingExpandedSize.height)
                child.setNeedsLayout()
                child.layoutIfNeeded()
                let size = child.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let height = size.height.rounded(.up)
                child.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
                style.height = .points(height)
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        case .viewWidth:
            if child.frame.width.rounded(.up) != bounds.width.rounded(.up) || child.frame.width.isZero {
                child.frame.size = CGSize(width: UIView.layoutFittingExpandedSize.width, height: bounds.height)
                child.setNeedsLayout()
                child.layoutIfNeeded()
                let size = child.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let width = size.width.rounded(.up)
                child.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
                style.width = .points(width)
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        case .viewSize:
            if child.frame.width.rounded(.up) != bounds.width.rounded(.up) || child.frame.width.isZero || child.frame.height.rounded(.up) != bounds.height.rounded(.up) || child.frame.height.isZero {
                child.frame.size = CGSize(width: UIView.layoutFittingExpandedSize.width, height: UIView.layoutFittingExpandedSize.width)
                child.setNeedsLayout()
                child.layoutIfNeeded()
                let size = child.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                child.frame = CGRect(origin: .zero, size: size)
                style.preferredSize = size
                setNeedsLayout()
            } else {
                child.frame = bounds
            }
        }
    }
}
