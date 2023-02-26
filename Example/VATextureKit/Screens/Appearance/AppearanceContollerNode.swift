//
//  AppearanceContollerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class AppearanceContollerNode: VASafeAreaDisplayNode {
    let pickerNode = VAViewWrapperNode(childGetter: { UIPickerView() }, sizing: .inheritedHeight)
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                pickerNode
            }
        }
    }
}
