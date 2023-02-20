//
//  AppearanceContollerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class AppearanceContollerNode: VASafeAreaDisplayNode {
    let pickerNode = VAViewWrapperNode(childGetter: { UIPickerView() }, sizing: .inheritedHeight)
    
    override func configureTheme() {
        backgroundColor = theme.background
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                pickerNode
            }
        }
    }
}
