//
//  VABaseDisplayNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 18.02.2023.
//

import AsyncDisplayKit

open class VABaseDisplayNode: ASDisplayNode {
    
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
