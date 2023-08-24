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
    public private(set) lazy var child: T = childGetter()
    
    private let childGetter: () -> T
    private let sizing: Sizing?
    
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
    
    open override func didLoad() {
        super.didLoad()
        
        switch sizing {
        case .inheritedHeight:
            style.height = .points(child.frame.height)
        case .inheritedWidth:
            style.width = .points(child.frame.width)
        case .inheritedSize:
            style.preferredSize = child.frame.size
        default:
            break
        }
        view.addSubview(child)
    }
    
    open override func layout() {
        super.layout()

        child.frame = bounds
    }
}
