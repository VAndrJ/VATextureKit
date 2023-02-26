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

extension ASDisplayNode {
    
    // Capitalized for beauty when used
    public func SafeArea(_ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        layoutSpec()
            .padding(.insets(safeAreaInsets))
    }
    
    // Capitalized for beauty when used
    public func SafeArea(_ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        layoutElement()
            .padding(.insets(safeAreaInsets))
    }
}
