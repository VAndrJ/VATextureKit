//
//  VASpacerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 29.03.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

/// Subclass of `ASDisplayNode` designed to provide spacing within layout hierarchies.
public class VASpacerNode: ASDisplayNode, @unchecked Sendable {

    public override init() {
        super.init()

        style.flexShrink = 0.1
        style.flexGrow = 1
        isUserInteractionEnabled = false
    }

    public init(flexShrink: CGFloat, flexGrow: CGFloat) {
        super.init()

        style.flexShrink = flexShrink
        style.flexGrow = flexGrow
        isUserInteractionEnabled = false
    }
}
