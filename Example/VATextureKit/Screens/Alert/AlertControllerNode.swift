//
//  AlertControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit
import Swiftional

class AlertControllerNode: VASafeAreaDisplayNode {
    let buttonNode = VAButtonNode()
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        buttonNode.setTitle(
            "Show alert",
            with: nil,
            with: theme.systemBlue,
            for: .normal
        )
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                buttonNode
            }
        }
    }
}
