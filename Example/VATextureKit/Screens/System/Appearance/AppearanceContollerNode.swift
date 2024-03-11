//
//  AppearanceContollerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class AppearanceContollerNode: ScreenNode {
    let pickerNode = VAViewWrapperNode(
        actorChildGetter: { UIPickerView() },
        sizing: .inheritedHeight
    )
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        backgroundColor = theme.systemBackground
        pickerNode.child.reloadAllComponents()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                pickerNode
            }
        }
    }
}
