//
//  VAViewWrapperNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

/// A custom ASDisplayNode subclass for wrapping UIViews with various sizing options.
open class VAViewWrapperNode<T: UIView>: VADisplayNode {
    public enum Sizing {
        case inheritedHeight
        case inheritedWidth
        case inheritedSize
        case fixedHeight(CGFloat)
        case fixedWidth(CGFloat)
        case fixedSize(CGSize)
    }

    /// The wrapped UIView instance.
    @MainActor
    public private(set) lazy var child: T = childGetter()

    @MainActor
    private let childGetter: () -> T
    private let sizing: Sizing?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - actorChildGetter: A closure returning the UIView instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    @available (iOS 13.0, *)
    public init(actorChildGetter: @escaping @MainActor () -> T, sizing: Sizing? = nil) {
        self.sizing = sizing
        self.childGetter = actorChildGetter

        super.init()

        switch sizing {
        case let .fixedWidth(width):
            style.width = .points(width)
        case let .fixedHeight(height):
            style.height = .points(height)
        case let .fixedSize(size):
            style.preferredSize = size
        default:
            break
        }
    }
    
    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - childGetter: A closure returning the UIView instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    public init(childGetter: @escaping () -> T, sizing: Sizing? = nil) {
        self.sizing = sizing
        self.childGetter = childGetter
        
        super.init()
        
        switch sizing {
        case let .fixedWidth(width):
            style.width = .points(width)
        case let .fixedHeight(height):
            style.height = .points(height)
        case let .fixedSize(size):
            style.preferredSize = size
        default:
            break
        }
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        var needsLayout = false
        switch sizing {
        case .inheritedHeight:
            style.height = .points(child.frame.height)
            needsLayout = true
        case .inheritedWidth:
            style.width = .points(child.frame.width)
            needsLayout = true
        case .inheritedSize:
            style.preferredSize = child.frame.size
            needsLayout = true
        default:
            break
        }
        view.addSubview(child)
        if needsLayout {
            setNeedsLayout()
        }
    }

    @MainActor
    open override func layout() {
        super.layout()

        child.frame = bounds
    }
}
