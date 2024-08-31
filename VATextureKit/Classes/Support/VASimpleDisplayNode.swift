//
//  VASimpleDisplayNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 8/31/24.
//

public import AsyncDisplayKit

open class VASimpleDisplayNode: ASDisplayNode, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidload()
        }
    }

    @MainActor
    open func viewDidload() {}
}
