//
//  ContentSizeControllerNode.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 20.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class ContentSizeControllerNode: VASafeAreaDisplayNode {
    let contentSizeTextNode = VATextNode(textStyle: .title3, alignment: .center)
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                contentSizeTextNode
                    .padding(.all(16))
            }
        }
    }
}
