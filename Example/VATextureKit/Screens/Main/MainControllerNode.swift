//
//  MainControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class MainControllerNode: VASafeAreaDisplayNode {
    let listNode = ASTableNode()
    let descriptionNode = VATextNode(text: "Examples", textStyle: .headline)
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            listNode
                .flex(shrink: 0.1, grow: 1)
            descriptionNode
                .centered(centering: .X)
        }
        .padding(.insets(safeAreaInsets))
    }
}
