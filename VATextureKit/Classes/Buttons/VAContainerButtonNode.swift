//
//  VAContainerButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

import AsyncDisplayKit

public final class VAContainerButtonNode<Node: ASDisplayNode>: VAButtonNode {
    public let child: Node

    public init(child: Node, onTap: @escaping () -> Void) {
        self.child = child

        super.init()

        self.onTap = onTap
        automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .wrapped()
    }
}
