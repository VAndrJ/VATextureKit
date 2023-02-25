//
//  VAButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import AsyncDisplayKit

open class VAButtonNode: ASButtonNode {
    public var onTap: (() -> Void)?
    
    open override func didLoad() {
        super.didLoad()
        
        bind()
    }
    
    @objc private func touchUpInside() {
        onTap?()
    }
    
    private func bind() {
        addTarget(
            self,
            action: #selector(touchUpInside),
            forControlEvents: .touchUpInside
        )
    }
}
