//
//  VAViewWrapperNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VAViewWrapperNode<T: UIView>: VADisplayNode {
    public enum Sizing {
        case inheritedHeight
        case inheritedWidth
        case inheritedSize
        case fixedHeight(CGFloat)
        case fixedWidth(CGFloat)
        case fixedSize(CGSize)
    }
    
    public private(set) lazy var child: T = childGetter()
    
    private let childGetter: () -> T
    private let sizing: Sizing?
    
    public init(childGetter: @escaping () -> T, sizing: Sizing? = nil) {
        self.sizing = sizing
        self.childGetter = childGetter
        
        super.init()
        
        switch sizing {
        case let .fixedWidth(width):
            style.width = ASDimension(unit: .points, value: width)
        case let .fixedHeight(height):
            style.height = ASDimension(unit: .points, value: height)
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
            style.height = ASDimension(unit: .points, value: child.frame.height)
        case .inheritedWidth:
            style.width = ASDimension(unit: .points, value: child.frame.width)
        case .inheritedSize:
            style.preferredSize = child.frame.size
        default:
            break
        }
        view.addSubview(child)
    }
    
    public override func layout() {
        super.layout()

        child.frame = bounds
    }
}
