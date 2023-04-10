//
//  VAContainerCellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//

import AsyncDisplayKit

open class VAContainerCellNode<Node: ASDisplayNode>: VACellNode {
    public let childNode: Node

    init(childNode: Node) {
        self.childNode = childNode
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        childNode
            .wrapped()
    }
}
