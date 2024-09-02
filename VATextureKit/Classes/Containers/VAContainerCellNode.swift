//
//  VAContainerCellNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VAContainerCellNode<Node: ASDisplayNode>: VACellNode, @unchecked Sendable {
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
