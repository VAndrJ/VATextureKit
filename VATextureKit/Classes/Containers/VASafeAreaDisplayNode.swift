//
//  VASafeAreaDisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VASafeAreaDisplayNode: VADisplayNode, @unchecked Sendable {
    
    public override init(corner: VACornerRoundingParameters = .default) {
        super.init(corner: corner)
        
        automaticallyRelayoutOnSafeAreaChanges = true
    }
}
