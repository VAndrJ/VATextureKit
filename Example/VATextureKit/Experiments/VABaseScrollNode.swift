//
//  VABaseScrollNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit

open class VABaseScrollNode: ASScrollNode {
    
    public override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
        view.contentInsetAdjustmentBehavior = .never
    }
}
