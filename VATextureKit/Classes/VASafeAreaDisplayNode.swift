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
