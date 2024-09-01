//
//  VASpacerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 29.03.2023.
//

public import AsyncDisplayKit

/// Subclass of `ASDisplayNode` designed to provide spacing within layout hierarchies.
public class VASpacerNode: ASDisplayNode {

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
