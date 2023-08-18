//
//  VASafeAreaDisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VASafeAreaDisplayNode: VADisplayNode {
    
    public override init() {
        super.init()
        
        automaticallyRelayoutOnSafeAreaChanges = true
    }
}

// MARK: - Capitalized for beauty when used

extension ASDisplayNode {

    public func SafeArea(_ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        layoutElement()
            .padding(.insets(safeAreaInsets))
    }

    public func SafeArea(edges: VASafeAreaEdge, _ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        ASInsetLayoutSpec(
            insets: UIEdgeInsets(paddings: mapToPaddings(edges: edges, in: self)),
            child: layoutElement()
        )
    }
}
