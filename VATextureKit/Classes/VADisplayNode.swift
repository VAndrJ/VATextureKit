//
//  VADisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VADisplayNode: ASDisplayNode {
    
    public override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
#if DEBUG || targetEnvironment(simulator)
    open override func didLoad() {
        super.didLoad()
        
        addDebugLabel()
    }
#endif
}
