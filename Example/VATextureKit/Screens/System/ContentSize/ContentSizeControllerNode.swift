//
//  ContentSizeControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ContentSizeNavigationIdentity: DefaultNavigationIdentity {}

final class ContentSizeControllerNode: VASafeAreaDisplayNode {
    let contentSizeTextNode = VATextNode(fontStyle: .title3, alignment: .center)
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
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
