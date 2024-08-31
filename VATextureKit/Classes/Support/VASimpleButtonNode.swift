//
//  VASimpleButtonNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 8/31/24.
//

public import AsyncDisplayKit

open class VASimpleButtonNode: ASButtonNode, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidload()
        }
    }

    @MainActor
    open func viewDidload() {}

    open override func layout() {
        super.layout()

        MainActor.assumeIsolated {
            layoutSubviews()
        }
    }

    @MainActor
    open func layoutSubviews() {}
}
