//
//  VAButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import AsyncDisplayKit

@MainActor
open class VAButtonNode: ASButtonNode {
    public var onTap: (() -> Void)?
    
    open override func didLoad() {
        super.didLoad()
        
        bind()
    }

    public func onTap<T: AnyObject>(weakify object: T, block: @escaping (T) -> Void) {
        onTap = { [weak object] in
            guard let object else { return }
            block(object)
        }
    }

    public func onTap<T: AnyObject, U: AnyObject>(weakify objects: (T, U), block: @escaping (T, U) -> Void) {
        onTap = { [weak object0 = objects.0, weak object1 = objects.1] in
            guard let object0, let object1 else { return }
            block(object0, object1)
        }
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
