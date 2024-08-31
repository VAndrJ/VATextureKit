//
//  VAContainerCellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//

public import AsyncDisplayKit

open class VAContainerCellNode<Node: ASDisplayNode>: VACellNode {
    public let childNode: Node

    public init(childNode: Node) {
        self.childNode = childNode

        super.init()
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        childNode
            .wrapped()
    }
}
